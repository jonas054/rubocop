# Lint

## Lint/AmbiguousOperator

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for ambiguous operators in the first argument of a
method invocation without parentheses.

### Example

```ruby
array = [1, 2, 3]

# The `*` is interpreted as a splat operator but it could possibly be
# a `*` method invocation (i.e. `do_something.*(array)`).
do_something *array

# With parentheses, there's no ambiguity.
do_something(*array)
```

## Lint/AmbiguousRegexpLiteral

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for ambiguous regexp literals in the first argument of
a method invocation without parentheses.

### Example

```ruby
# This is interpreted as a method invocation with a regexp literal,
# but it could possibly be `/` method invocations.
# (i.e. `do_something./(pattern)./(i)`)
do_something /pattern/i

# With parentheses, there's no ambiguity.
do_something(/pattern/i)
```

## Lint/AssignmentInCondition

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for assignments in the conditions of
if/while/until.

### Important attributes

Attribute | Value
--- | ---
AllowSafeAssignment | true


## Lint/BlockAlignment

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks whether the end keywords are aligned properly for do
end blocks.

Three modes are supported through the `EnforcedStyleAlignWith`
configuration parameter:

`start_of_block` : the `end` shall be aligned with the
start of the line where the `do` appeared.

`start_of_line` : the `end` shall be aligned with the
start of the line where the expression started.

`either` (which is the default) : the `end` is allowed to be in either
location. The autofixer will default to `start_of_line`.

### Example

```ruby
# either
variable = lambda do |i|
  i
end

# start_of_block
foo.bar
  .each do
     baz
   end

# start_of_line
foo.bar
  .each do
     baz
end
```

### Important attributes

Attribute | Value
--- | ---
EnforcedStyleAlignWith | either
SupportedStylesAlignWith | either, start_of_block, start_of_line


## Lint/CircularArgumentReference

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for circular argument references in optional keyword
arguments and optional ordinal arguments.

This cop mirrors a warning produced by MRI since 2.2.

### Example

```ruby
# bad
def bake(pie: pie)
  pie.heat_up
end

# good
def bake(pie:)
  pie.refrigerate
end

# good
def bake(pie: self.pie)
  pie.feed_to(user)
end

# bad
def cook(dry_ingredients = dry_ingredients)
  dry_ingredients.reduce(&:+)
end

# good
def cook(dry_ingredients = self.dry_ingredients)
  dry_ingredients.combine
end
```

## Lint/ConditionPosition

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for conditions that are not on the same line as
if/while/until.

### Example

```ruby
if
  some_condition
  do_something
end
```

## Lint/Debugger

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for calls to debugger or pry.

## Lint/DefEndAlignment

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks whether the end keywords of method definitions are
aligned properly.

Two modes are supported through the EnforcedStyleAlignWith configuration
parameter. If it's set to `start_of_line` (which is the default), the
`end` shall be aligned with the start of the line where the `def`
keyword is. If it's set to `def`, the `end` shall be aligned with the
`def` keyword.

### Example

```ruby
private def foo
end
```

### Important attributes

Attribute | Value
--- | ---
EnforcedStyleAlignWith | start_of_line
SupportedStylesAlignWith | start_of_line, def
AutoCorrect | false


## Lint/DeprecatedClassMethods

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for uses of the deprecated class method usages.

## Lint/DuplicateCaseCondition

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks that there are no repeated conditions
used in case 'when' expressions.

### Example

```ruby
# bad
case x
when 'first'
  do_something
when 'first'
  do_something_else
end
```

## Lint/DuplicateMethods

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for duplicated instance (or singleton) method
definitions.

### Example

```ruby
# bad
def duplicated
  1
end

def duplicated
  2
end
```

## Lint/DuplicatedKey

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for duplicated keys in hash literals.

This cop mirrors a warning in Ruby 2.2.

### Example

```ruby
hash = { food: 'apple', food: 'orange' }
```

## Lint/EachWithObjectArgument

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks if each_with_object is called with an immutable
argument. Since the argument is the object that the given block shall
make calls on to build something based on the enumerable that
each_with_object iterates over, an immutable argument makes no sense.
It's definitely a bug.

### Example

```ruby
sum = numbers.each_with_object(0) { |e, a| a += e }
```

## Lint/ElseLayout

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for odd else block layout - like
having an expression on the same line as the else keyword,
which is usually a mistake.

### Example

```ruby
if something
  ...
else do_this
  do_that
end
```

## Lint/EmptyEnsure

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for empty `ensure` blocks

## Lint/EmptyExpression

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for the presence of empty expressions.

### Example

```ruby
# bad
foo = ()
if ()
  bar
end
```

## Lint/EmptyInterpolation

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for empty interpolation.

### Example

```ruby
"result is #{}"
```

## Lint/EmptyWhen

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for the presence of `when` branches without a body.

### Example

```ruby
# bad
case foo
when bar then 1
when baz then # nothing
end
```

## Lint/EndAlignment

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks whether the end keywords are aligned properly.

Three modes are supported through the `EnforcedStyleAlignWith`
configuration parameter:

If it's set to `keyword` (which is the default), the `end`
shall be aligned with the start of the keyword (if, class, etc.).

If it's set to `variable` the `end` shall be aligned with the
left-hand-side of the variable assignment, if there is one.

If it's set to `start_of_line`, the `end` shall be aligned with the
start of the line where the matching keyword appears.

### Example

```ruby
# good
# keyword style
variable = if true
           end

# variable style
variable = if true
end

# start_of_line style
puts(if true
end)
```

### Important attributes

Attribute | Value
--- | ---
EnforcedStyleAlignWith | keyword
SupportedStylesAlignWith | keyword, variable, start_of_line
AutoCorrect | false


## Lint/EndInMethod

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for END blocks in method definitions.

## Lint/EnsureReturn

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for *return* from an *ensure* block.

## Lint/Eval

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for the use of *Kernel#eval*.

## Lint/FloatOutOfRange

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop identifies Float literals which are, like, really really really
really really really really really big. Too big. No-one needs Floats
that big. If you need a float that big, something is wrong with you.

### Example

```ruby
# bad
float = 3.0e400

# good
float = 42.9
```

## Lint/FormatParameterMismatch

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This lint sees if there is a mismatch between the number of
expected fields for format/sprintf/#% and what is actually
passed as arguments.

### Example

```ruby
format('A value: %s and another: %i', a_value)
```

## Lint/HandleExceptions

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for *rescue* blocks with no body.

## Lint/ImplicitStringConcatenation

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for implicit string concatenation of string literals
which are on the same line.

### Example

```ruby
# bad
array = ['Item 1' 'Item 2']

# good
array = ['Item 1Item 2']
array = ['Item 1' + 'Item 2']
array = [
  'Item 1' \
  'Item 2'
]
```

## Lint/IneffectiveAccessModifier

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for `private` or `protected` access modifiers which are
applied to a singleton method. These access modifiers do not make
singleton methods private/protected. `private_class_method` can be
used for that.

### Example

```ruby
# bad
class C
  private

  def self.method
    puts 'hi'
  end
end

# good
class C
  def self.method
    puts 'hi'
  end

  private_class_method :method
end

class C
  class << self
    private

    def method
      puts 'hi'
    end
  end
end
```

## Lint/InheritException

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop looks for error classes inheriting from `Exception`
and its standard library subclasses, excluding subclasses of
`StandardError`. It is configurable to suggest using either
`RuntimeError` (default) or `StandardError` instead.

### Example

```ruby
# bad

class C < Exception; end
```
```ruby
# EnforcedStyle: runtime_error (default)

# good

class C < RuntimeError; end
```
```ruby
# EnforcedStyle: standard_error

# good

class C < StandardError; end
```

### Important attributes

Attribute | Value
--- | ---
EnforcedStyle | runtime_error
SupportedStyles | runtime_error, standard_error


## Lint/InvalidCharacterLiteral

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for invalid character literals with a non-escaped
whitespace character (e.g. `? `).
However, currently it's unclear whether there's a way to emit this
warning without syntax errors.

    $ ruby -w
    p(? )
    -:1: warning: invalid character syntax; use ?\s
    -:1: syntax error, unexpected '?', expecting ')'
    p(? )
       ^

### Example

```ruby
p(? )
```

## Lint/LiteralInCondition

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for literals used as the conditions or as
operands in and/or expressions serving as the conditions of
if/while/until.

### Example

```ruby
if 20
  do_something
end

if some_var && true
  do_something
end
```

## Lint/LiteralInInterpolation

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for interpolated literals.

### Example

```ruby
"result is #{10}"
```

## Lint/Loop

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for uses of *begin...end while/until something*.

## Lint/NestedMethodDefinition

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for nested method definitions.

### Example

```ruby
# `bar` definition actually produces methods in the same scope
# as the outer `foo` method. Furthermore, the `bar` method
# will be redefined every time `foo` is invoked.
def foo
  def bar
  end
end
```

## Lint/NextWithoutAccumulator

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't omit the accumulator when calling `next` in a `reduce` block.

### Example

```ruby
# bad
result = (1..4).reduce(0) do |acc, i|
  next if i.odd?
  acc + i
end

# good
result = (1..4).reduce(0) do |acc, i|
  next acc if i.odd?
  acc + i
end
```

## Lint/NonLocalExitFromIterator

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for non-local exit from iterator, without return value.
It warns only when satisfies all of these: `return` doesn't have return
value, the block is preceded by a method chain, the block has arguments,
and the method which receives the block is not `define_method`
or `define_singleton_method`.

### Example

```ruby
class ItemApi
  rescue_from ValidationError do |e| # non-iteration block with arg
    return message: 'validation error' unless e.errors # allowed
    error_array = e.errors.map do |error| # block with method chain
      return if error.suppress? # warned
      return "#{error.param}: invalid" unless error.message # allowed
      "#{error.param}: #{error.message}"
    end
    message: 'validation error', errors: error_array
  end

  def update_items
    transaction do # block without arguments
      return unless update_necessary? # allowed
      find_each do |item| # block without method chain
        return if item.stock == 0 # false-negative...
        item.update!(foobar: true)
      end
    end
  end
end
```

## Lint/ParenthesesAsGroupedExpression

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Checks for space between a the name of a called method and a left
parenthesis.

### Example

```ruby
puts (x + y)
```

## Lint/PercentStringArray

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for quotes and commas in %w, e.g.

  `%w('foo', "bar")`

it is more likely that the additional characters are unintended (for
example, mistranslating an array of literals to percent string notation)
rather than meant to be part of the resulting strings.

## Lint/PercentSymbolArray

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for colons and commas in %i, e.g.

  `%i(:foo, :bar)`

it is more likely that the additional characters are unintended (for
example, mistranslating an array of literals to percent string notation)
rather than meant to be part of the resulting symbols.

## Lint/RandOne

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for `rand(1)` calls.
Such calls always return `0`.

### Example

```ruby
# bad
rand 1
Kernel.rand(-1)
rand 1.0
rand(-1.0)

# good
0
```

## Lint/RequireParentheses

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for expressions where there is a call to a predicate
method with at least one argument, where no parentheses are used around
the parameter list, and a boolean operator, && or ||, is used in the
last argument.

The idea behind warning for these constructs is that the user might
be under the impression that the return value from the method call is
an operand of &&/||.

### Example

```ruby
if day.is? :tuesday && month == :jan
  ...
end
```

## Lint/RescueException

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for *rescue* blocks targeting the Exception class.

## Lint/ShadowedException

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for a rescued exception that get shadowed by a
less specific exception being rescued before a more specific
exception is rescued.

### Example

```ruby
# bad
begin
  something
rescue Exception
  handle_exception
rescue StandardError
  handle_standard_error
end

# good
begin
  something
rescue StandardError
  handle_standard_error
rescue Exception
  handle_exception
end
```

## Lint/ShadowingOuterLocalVariable

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop looks for use of the same name as outer local variables
for block arguments or block local variables.
This is a mimic of the warning
"shadowing outer local variable - foo" from `ruby -cw`.

## Lint/StringConversionInInterpolation

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for string conversion in string interpolation,
which is redundant.

### Example

```ruby
"result is #{something.to_s}"
```

## Lint/UnderscorePrefixedVariableName

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for underscore-prefixed variables that are actually
used.

## Lint/UnifiedInteger

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for using Fixnum or Bignum constant.

### Example

```ruby
# bad
1.is_a?(Fixnum)
1.is_a?(Bignum)

# good
1.is_a?(Integer)
```

## Lint/UnneededDisable

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop detects instances of rubocop:disable comments that can be
removed without causing any offenses to be reported. It's implemented
as a cop in that it inherits from the Cop base class and calls
add_offense. The unusual part of its implementation is that it doesn't
have any on_* methods or an investigate method. This means that it
doesn't take part in the investigation phase when the other cops do
their work. Instead, it waits until it's called in a later stage of the
execution. The reason it can't be implemented as a normal cop is that
it depends on the results of all other cops to do its work.

## Lint/UnneededSplatExpansion

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for unneeded usages of splat expansion

### Example

```ruby
# bad
a = *[1, 2, 3]
a = *'a'
a = *1

begin
  foo
rescue *[StandardError, ApplicationError]
  bar
end

case foo
when *[1, 2, 3]
  bar
else
  baz
end

# good
c = [1, 2, 3]
a = *c
a, b = *c
a, *b = *c
a = *1..10
a = ['a']

begin
  foo
rescue StandardError, ApplicationError
  bar
end

case foo
when *[1, 2, 3]
  bar
else
  baz
end
```

## Lint/UnreachableCode

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for unreachable code.
The check are based on the presence of flow of control
statement in non-final position in *begin*(implicit) blocks.

## Lint/UnusedBlockArgument

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for unused block arguments.

### Example

```ruby
#good

do_something do |used, unused|
  puts used
end

do_something do
  puts :foo
end

define_method(:foo) do |_bar|
  puts :baz
end

# bad

do_something do |used, _unused|
  puts used
end

do_something do |bar|
  puts :foo
end

define_method(:foo) do |bar|
  puts :baz
end
```

### Important attributes

Attribute | Value
--- | ---
IgnoreEmptyBlocks | true
AllowUnusedKeywordArguments | false


## Lint/UnusedMethodArgument

Enabled by default | Supports autocorrection
--- | ---
Enabled | Yes

This cop checks for unused method arguments.

### Example

```ruby
def some_method(used, unused, _unused_but_allowed)
  puts used
end
```

### Important attributes

Attribute | Value
--- | ---
AllowUnusedKeywordArguments | false
IgnoreEmptyMethods | true


## Lint/UselessAccessModifier

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for redundant access modifiers, including those with no
code, those which are repeated, and leading `public` modifiers in a
class or module body. Conditionally-defined methods are considered as
always being defined, and thus access modifiers guarding such methods
are not redundant.

### Example

```ruby
class Foo
  public # this is redundant (default access is public)

  def method
  end

  private # this is not redundant (a method is defined)
  def method2
  end

  private # this is redundant (no following methods are defined)
end
```
```ruby
class Foo
  # The following is not redundant (conditionally defined methods are
  # considered as always defining a method)
  private

  if condition?
    def method
    end
  end

  protected # this is not redundant (method is defined)

  define_method(:method2) do
  end

  protected # this is redundant (repeated from previous modifier)

  [1,2,3].each do |i|
    define_method("foo#{i}") do
    end
  end

  # The following is redundant (methods defined on the class'
  # singleton class are not affected by the public modifier)
  public

  def self.method3
  end
end
```
```ruby
# Lint/UselessAccessModifier:
#   ContextCreatingMethods:
#     - concerning
require 'active_support/concern'
class Foo
  concerning :Bar do
    def some_public_method
    end

    private

    def some_private_method
    end
  end

  # this is not redundant because `concerning` created its own context
  private

  def some_other_private_method
  end
end
```

### Important attributes

Attribute | Value
--- | ---
ContextCreatingMethods | 


## Lint/UselessAssignment

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for every useless assignment to local variable in every
scope.
The basic idea for this cop was from the warning of `ruby -cw`:

  assigned but unused variable - foo

Currently this cop has advanced logic that detects unreferenced
reassignments and properly handles varied cases such as branch, loop,
rescue, ensure, etc.

## Lint/UselessComparison

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for comparison of something with itself.

### Example

```ruby
x.top >= x.top
```

## Lint/UselessElseWithoutRescue

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for useless `else` in `begin..end` without `rescue`.

### Example

```ruby
begin
  do_something
else
  handle_errors # This will never be run.
end
```

## Lint/UselessSetterCall

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for setter call to local variable as the final
expression of a function definition.

### Example

```ruby
def something
  x = Something.new
  x.attr = 5
end
```

## Lint/Void

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cop checks for operators, variables and literals used
in void context.
