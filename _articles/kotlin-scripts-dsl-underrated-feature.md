---
title: Combining scripts and DSLs is Kotlin’s most underrated feature
date: '2022-03-23'
excerpt: >-
  The more I play with Kotlin, the more convinced I am that a combo of two of
  its features is vastly underrated: first, the ability to create
  domain-specific languages (DSL), thanks to some syntactic sugar; then, the
  ability to write scripts and create interpreters for them.
cover: /assets/posts/kotlin-scripts-dsl-underrated-feature/cover.png
---

I discovered Kotlin recently and realized that, for many people, it was only a new syntax for Java. But the more I play with it, the more convinced I am that a combo of two of its features is vastly underrated:

- The ability to create domain-specific languages (DSL), thanks to some syntactic sugar;
- The ability to write scripts and create interpreters for them.

You can easily guess how nice these features can play together. We can create a DSL, tailor it to our needs, and use it in scripts. Why scripts? Let me introduce the example I will develop here to illustrate why.

Not long ago, I started keeping track of my personal finances. I wanted to keep track of the total value of everything I own (money in bank accounts, stocks, real estate), and I was disappointed in the third-party services I found. So I developed my own tool to fit my needs. [(Want to know more? I wrote a book about it!)](https://scastiel.gumroad.com/l/kotlin-net-worth)

My program’s input had to be the values of my accounts over time (I wanted to manually write each value instead of relying on an unreliable API to fetch them automatically). To provide this input, I had quite a few options:

- I could store them in a database and develop tools to populate it (a GUI, a CLI…)
- I could put them in a JSON file
- Why not store them in a Kotlin file?

Providing the input in a Kotlin file sounded like a weird thing to do. On the one hand, I could benefit from IntelliJ’s autocomplete features since I would use the functions and classes I wrote. On the other hand, it meant I would have to rebuild the program each time I updated the input?? How unpractical does it seem?

Here is where scripts come into play. With Kotlin, you can write a script interpreter embedding your domain logic, including a DSL, and write scripts providing the input to that logic.

In this article, we’ll build a “minimum viable example”, a _net worth tracker_ to demonstrate how it can work. But if you already know Kotlin, you likely already use scripts and DSLs without even knowing it: in your *build.gradle.kts* file, you are using the Gradle DSL in a script!

_The full example is [available on GitHub](https://github.com/scastiel/kt-dsl-scripts). The [main](https://github.com/scastiel/kt-dsl-scripts) branch contains the final version, and you’ll find there two branches [step-1](https://github.com/scastiel/kt-dsl-scripts/tree/step-1) and [step-2](https://github.com/scastiel/kt-dsl-scripts/tree/step-2) with the code of the first two sections. I removed the imports from the code examples to make the post lighter, but you can follow the link attached to code blocks to see the full file content._

## Step 1: Create the domain logic

We want to write a program that takes accounts and snapshots as inputs and displays a report as an output. A snapshot represents the states of several accounts at a given date, so the class contains a date attribute and a mapping between accounts and their respective value.

```kotlin
// https://tinyurl.com/yckwfds4
data class Account(val id: String, val name: String)
```

```kotlin
// https://tinyurl.com/57vr36mw
data class Snapshot(val date: LocalDate, val balances: Map<Account, Double>)
```

To create a report, we need to provide a list of accounts and snapshots. Our minimal report will have two features: displaying the account list and displaying each snapshot (with, for each of them, the value of each account).
   
```kotlin
// https://tinyurl.com/2whmpup6
class Report(val accounts: List<Account>, val snapshots: List<Snapshot>) {
  fun displayAccountList() {
    println("ACCOUNTS:")
    accounts.forEach { println("- ${it.name}") }
  }

  fun displaySnapshots() {
    println("SNAPSHOTS:")
    snapshots.forEach { snapshot ->
      println("* ${snapshot.date}:")
      accounts.forEach { account ->
        println("  - ${account.name}: ${snapshot.balances[account]?.toString() ?: "-"}")
      }
    }
  }
}
```

As a first step, let’s use these classes in the `main` function. We first create two accounts, then two snapshots defining a value for these accounts. Finally, we create a report and display the accounts’ and the snapshots’ list.
   
```kotlin
// https://tinyurl.com/s8564hy5
fun main(args: Array<String>) {
  val checking = Account("checking", "Checking")
  val savings = Account("savings", "Savings")

  val snapshots = listOf(
    Snapshot(
      LocalDate.parse("2022-01-01"),
      mapOf(checking to 1000.0, savings to 2000.0)
    ),
    Snapshot(
      LocalDate.parse("2022-02-01"),
      mapOf(checking to 1200.0, savings to 2500.0)
    )
  )

  val report = Report(listOf(checking, savings), snapshots)
  report.displayAccountList()
  report.displaySnapshots()
}
```

Ok, our program works, but we will improve it in two ways: first, we will make it possible to extract the content of `main` into a script (so we don’t have to rebuild the application when we add new snapshots), then we will create some helpers (our DSL) to make it easier to edit the script.

## Step 2: Create a script definition

Using Kotlin to write scripts is unfortunately not a very well-documented feature. It changed a lot in the past, so the tutorials you can find are not always still valid. But it doesn’t mean we cannot enjoy it!

The first step is to include some dependencies to our project:
   
```kotlin
// https://tinyurl.com/5ase8sdr
dependencies {
  // ...
  implementation("org.jetbrains.kotlin:kotlin-scripting-common:1.6.0")
  implementation("org.jetbrains.kotlin:kotlin-scripting-jvm:1.6.0")
  implementation("org.jetbrains.kotlin:kotlin-scripting-jvm-host:1.6.0")
}
```

To be able to write a script interpreter, we need to create two entities: a script *definition* and a script *host*. Let’s start with the script definition, `NwtScript` (`nwt` stands for _net worth tracker_). It can be as simple as an abstract class annotated with `@KotlinScript`. To make writing script easier, we can also provide some classes that will automatically be imported, using a `ScriptCompilationConfiguration` object:

```kotlin
// https://tinyurl.com/yc26svyp
@KotlinScript(
  fileExtension = "nwt.kts",
  compilationConfiguration = NwtScriptConfiguration::class
)
abstract class NwtScript

object NwtScriptConfiguration: ScriptCompilationConfiguration({
  defaultImports(Account::class, Snapshot::class, Report::class, LocalDate::class)
})
```

We also provide an extension for our scripts; note that, so we enjoy IntelliJ’s features such as autocomplete, this extension has to be composed of a prefix of your choice, then `.kts`.

We can now create the script host `NwtScriptHost` to use this script definition. This class has nothing very complex: it has a public `execFile` method that accepts a filename, evaluates it using a `BasicJvmScriptingHost`, and displays possible log messages.

```kotlin
// https://tinyurl.com/2p88u9a5
class NwtScriptHost {
  private fun evalFile(scriptFile: File): ResultWithDiagnostics<EvaluationResult> {
    val compilationConfiguration = createJvmCompilationConfigurationFromTemplate<NwtScript> {
      jvm {
        // Script will have access to everything in the classpath
        dependenciesFromCurrentContext(wholeClasspath = true)
      }
    }
    return BasicJvmScriptingHost().eval(scriptFile.toScriptSource(), compilationConfiguration, null)
  }

  fun execFile(path: String) {
    val scriptFile = File(path)
    val res = evalFile(scriptFile)

    res.reports.forEach {
      if (it.severity > ScriptDiagnostic.Severity.DEBUG) {
        println(" : ${it.message}" + if (it.exception == null) "" else ": ${it.exception}")
      }
    }
  }
}
```

As the final step before we create our script, we need to tell IntelliJ about our script definition, so it knows what classes we can access and provide the autocomplete and code annotation features we like.

We need to create a folder `src/main/resources/META-INF/kotlin/script/templates` and in it an empty file named [`nwt.script.NwtScript.classname`](https://github.com/scastiel/kt-dsl-scripts/blob/step-2/src/main/resources/META-INF/kotlin/script/templates/nwt.script.NwtScript.classname) (the full class name + `.classname`). Here is the part I’m least comfortable explaining because I found how to make it work on some forums and not in official documentation 😅.

After creating the file, rebuild the application, and you may need to restart IntelliJ, invalidate caches… To be honest, I’m not sure exactly what works, but in the end, when you create a `.nwt.kts` file (let’s say `my.nwt.kts` at the project’s root), IntelliJ should tell you there is a script definition available for it 🎉.

Put the content of `main` in the new script file, and if everything went well, you should see that IntelliJ annotates the parameters of `Account`, for instance:
   
```kotlin
// https://tinyurl.com/4enfpevm
val checking = Account("checking", "Checking")
val savings = Account("savings", "Savings")

val snapshotJanuary = Snapshot(
  LocalDate.parse("2022-01-01"),
  mapOf(checking to 1000.0, savings to 2000.0)
)
val snapshotFebruary = Snapshot(
  LocalDate.parse("2022-02-01"),
  mapOf(checking to 1200.0, savings to 2500.0)
)

val report = Report(
  listOf(checking, savings),
  listOf(snapshotJanuary, snapshotFebruary)
)
report.displayAccountList()
report.displaySnapshots()
```

To transform our program into an interpreter for our script, we can now update our `main` function:
   
```kotlin
// https://tinyurl.com/mpzhf66e
fun main(vararg args: String) {
  if (args.size != 1) {
    println("usage: <app> <script file>")
  } else {
    NwtScriptHost().execFile(args[0])
  }
}
```

To run it, we can update the project’s run configuration, defining “my.nwt.kts” in the *Program arguments* field. You will notice that the application won't be rebuilt if you update the script file and rerun it!

![Update the run configuration to include the script name as argument.](/assets/posts/kotlin-scripts-dsl-underrated-feature/run-config.png)

It is already lovely, but we can make our script better by providing high-level functions, so we don’t feel like writing code!

## Step 3: Create builders and the DSL

We will use a well-known design pattern to implement our DSL: [the Builder pattern](https://en.wikipedia.org/wiki/Builder_pattern). For instance, to create a `Snapshot`, we can create a class `SnapshotBuilder`. Its constructor takes two parameters: the snapshot’s date and a map of accounts (we will see later how we provide these accounts).
   
```kotlin
// https://tinyurl.com/4tuffu26
class SnapshotBuilder(val date: LocalDate, val accounts: Map<String, Account>) {
  private val balances: MutableMap<Account, Double> = mutableMapOf()

  fun balance(accountId: String, amount: Double) {
    val account = accounts[accountId] ?: throw Exception("Invalid account ID")
    balances[account] = amount
  }

  fun build(): Snapshot {
    return Snapshot(date, balances)
  }
}
```

To use the builder, we can call its `balance` method to define the accounts’ balances; then, we call the `build` method to get the snapshot.

```kotlin
val builder = SnapshotBuilder(LocalDate.parse("2022-01-01"), accounts)
builder.balance("checking", 1000.0)
builder.balance("savings", 2000.0)
val snapshot = builder.build()
```

But we can do better. We can define a `snapshot` function taking two parameters:

- `date`: the snapshot’s date,
- `initialize`: a function to initialize the builder. This function will receive the builder as `this` (thanks to the call to `apply`), meaning that we will be able to call the `balance` method without any prefix.

```kotlin
fun snapshot(val date: String, initialize: SnapshotBuilder.() -> Unit): Snapshot {
  // We’ll see soon where `accounts` comes from
  return SnapshotBuilder(LocalDate.parse(date), accounts).apply(initialize).build()
}

val snapshot = snapshot("2022-02-01") {
  balance("checking", 1000.0)
  balance("savings", 2000.0)
}
```

To me, this is what makes Kotlin great for writing DSLs. When using the `snapshot` function, you don’t realize you are creating and using a builder!

Let’s create another builder to build several snapshots as a next step. This new `SnapshotsBuilder` will use the `SnapshotBuilder` and embed the `snapshot` we just saw (renaming it `on` for a better DSL, you’ll see):

```kotlin
// https://tinyurl.com/52fbfhhn
class SnapshotsBuilder(val accounts: Map<String, Account>) {
  private val snapshots: MutableList<Snapshot> = mutableListOf()

  fun on(date: String, initialize: SnapshotBuilder.() -> Unit) {
    val snapshotBuilder = SnapshotBuilder(LocalDate.parse(date), accounts).apply(initialize)
    snapshots.add(snapshotBuilder.build())
  }

  fun build(): List<Snapshot> {
    return snapshots
  }
}
```

We will use this builder via another function, `snapshots`:
   
```kotlin
fun snapshots(initialize: SnapshotsBuilder.() -> Unit) {
  // We’ll see soon where `accounts` comes from
  snapshots.addAll(SnapshotsBuilder(accounts).apply(initialize).build())
}

snapshots {
  on("2022-01-01") {
    balance("checking", 1000.0)
    balance("savings", 2000.0)
  }
  on("2022-02-01") {
    balance("checking", 1200.0)
    balance("savings", 2500.0)
  }
}
```

Let’s continue by creating a builder for reports. The `ReportBuilder` class technically doesn’t implement the builder pattern since it doesn’t build anything (and doesn’t have a `build` method), but it will still be helpful to us:
   
```kotlin
// https://tinyurl.com/2v35d9fu
class ReportBuilder(val accounts: List<Account>, val snapshots: List<Snapshot>) {
  private val report = Report(accounts, snapshots)

  fun accounts() {
    report.displayAccountList()
  }

  fun snapshots() {
    report.displaySnapshots()
  }
}
```

Same as we did for snapshots, we can create a `report` function.
   
```kotlin
fun report(initialize: ReportBuilder.() -> Unit) {
  // We’ll see soon where `accounts` and `snapshots` come from
  ReportBuilder(accounts.values.toList(), snapshots).apply(initialize)
}

report {
  accounts()
  snapshots()
}
```

Last but not least, let’s create the last builder to unify them all! Our `NwtBuilder` embeds the `snapshots` and `report` functions as methods and is responsible for keeping the state of our program: the `accounts` and the `snapshots`:
   
```kotlin
// https://tinyurl.com/2p8n8av6
class NwtBuilder {
  private val accounts: MutableMap<String, Account> = mutableMapOf()
  private val snapshots: MutableList<Snapshot> = mutableListOf()

  fun account(id: String, name: String) {
    accounts[id] = Account(id, name)
  }

  fun snapshots(initialize: SnapshotsBuilder.() -> Unit) {
    snapshots.addAll(SnapshotsBuilder(accounts).apply(initialize).build())
  }

  fun report(initialize: ReportBuilder.() -> Unit) {
    ReportBuilder(accounts.values.toList(), snapshots).apply(initialize)
  }
}
```

```kotlin
// https://tinyurl.com/3cue36re
fun nwt(initialize: NwtBuilder.() -> Unit) {
  NwtBuilder().apply(initialize)
}
```

With the new `nwt` function, we won’t need access to the classes `Account`, `Snapshot`, and `Report` in the script. So we can update the script definition:

```kotlin
// https://tinyurl.com/mhecyc6n
@KotlinScript(fileExtension = "nwt.kts", compilationConfiguration = NwtScriptConfiguration::class)
abstract class NwtScript

object NwtScriptConfiguration: ScriptCompilationConfiguration({
  // give access to our `nwt` function without importing it
  defaultImports("nwt.dsl.nwt")
})
```

Now we have everything we need to update our script. No more `val`, no more explicit object creation. Only the bare minimum to provide to the interpreter the inputs (the accounts and their balances over time) and what we want as output (the report definition).

```kotlin
// https://tinyurl.com/3xh24mny
nwt {
  account("checking", "Checking")
  account("savings", "Savings")

  snapshots {
    on("2022-01-01") {
      balance("checking", 1000.0)
      balance("savings", 2000.0)
    }
    on("2022-02-01") {
      balance("checking", 1200.0)
      balance("savings", 2500.0)
    }
  }

  report {
    accounts()
    snapshots()
  }
}
```

Again, since we updated the script definition, you may need to rebuild the project, invalidate caches, restart IntelliJ, etc., to make it effective. But look at how nice it is that IntelliJ recognizes our DSL:

![IntelliJ recognizes our DSL!](/assets/posts/kotlin-scripts-dsl-underrated-feature/screenshot.png)

***

Kotlin is already widely used to write domain-specific languages. You can use it to write [Gradle configuration files](https://docs.gradle.org/current/userguide/kotlin_dsl.html), to [create HTML documents](https://kotlinlang.org/docs/typesafe-html-dsl.html), and I hope I convided you that creating your own DSL is worth it too, especially used in combination with the ability to write script interpreters.
