  # Markdown Cheat Sheet

  Don't render this with JavaScript. Use online renderer.

  Thanks for visiting [The Markdown Guide](https://www.markdownguide.org)!

  - [basic syntax](https://www.markdownguide.org/basic-syntax/)
  - [extended syntax](https://www.markdownguide.org/extended-syntax/).
  - [mermaid syntax](https://docs.mermaidchart.com/mermaid-oss/syntax/sequenceDiagram.html)

  ## Basic Syntax

  These are the elements outlined in John Gruber’s original design document. All Markdown applications support these elements.

  ### Heading

  # H1
  ## H2
  ### H3
  **bold text**
  *italicized text*

  ### Blockquote
  > blockquote
  > **Note**: this is wicked

  ### Ordered List

  1. First item
  2. Second item
  3. Third item

  - First item
  - Second item
  - Third item

  ### Code

  `code`

  ### Horizontal Rule

  ---

  ### Link

  [Markdown Guide](https://www.markdownguide.org)

  ### Image

  ![alt text](https://www.markdownguide.org/assets/images/tux.png)

  ## Extended Syntax

  These elements extend the basic syntax by adding additional features. Not all Markdown applications support these elements.

  ### Table

  | Syntax | Description |
  | ----------- | ----------- |
  | Header | Title |
  | Paragraph | Text |

  ### Fenced Code Block

  ```
  {
    "firstName": "John",
    "lastName": "Smith",
    "age": 25
  }
  ```

  ### Footnote

  Here's a sentence with a footnote. [^1]

  [^1]: This is the footnote that appears at the bottom.

  ### Heading ID

  ### My Great Heading {#custom-id}

  ### Definition List

  term
  : definition

  ### Strikethrough

  ~~The world is flat.~~

  ### Tables

  SmartyPants converts ASCII punctuation characters into "smart" typographic punctuation HTML entities. For example:

  |                |ASCII                          |HTML                         |
  |----------------|-------------------------------|-----------------------------|
  |Single backticks|`'Isn't this fun?'`            |'Isn't this fun?'            |
  |Quotes          |`"Isn't this fun?"`            |"Isn't this fun?"            |
  |Dashes          |`-- is en-dash, --- is em-dash`|-- is en-dash, --- is em-dash|

  ### Task List

  - [x] Write the press release
  - [ ] Update the website
  - [ ] Contact the media

  ### Emoji

  That is so funny! :joy:

  (See also [Copying and Pasting Emoji](https://www.markdownguide.org/extended-syntax/#copying-and-pasting-emoji))

  ### Highlight

  I need to highlight these ==very important words==.

  ### Subscript

  H~2~O

  ### Superscript

  X^2^

  ## KaTeX

  You can render LaTeX mathematical expressions using [KaTeX](https://khan.github.io/KaTeX/):

  The *Gamma function* satisfying $\Gamma(n) = (n-1)!\quad\forall n\in\mathbb N$ is via the Euler integral

  $$
  \Gamma(z) = \int_0^\infty t^{z-1}e^{-t}dt\,.
  $$

  > You can find more information about **LaTeX** mathematical expressions [here](http://meta.math.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference).


  ## Mermaid diagrams

  You can render UML diagrams using [Mermaid](https://mermaidjs.github.io/). For example, this will produce a sequence diagram:
  This will produce a flow chart:

  ```mermaid
  graph TB
  A[Square Rect] -- Link text --> B((Circle))
  A --> C(Round Rect)
  B --> D{Rhombus}
  C --> D
  ```

  ---
  ### **A Day**

  ```mermaid
  %%{init: {"theme":"dark"}}%%
  flowchart LR
  Fajr --> Dhuhr --> Asr --> Maghrib --> Isha
  ```

  ---
  ### **Example Flow (Two Servers)**

  ```mermaid
  sequenceDiagram
  Client->>Auth Server: POST /oauth/token (grant_type=password)
  Auth Server->>Client: JWT
  Client->>App Server: API request (Bearer JWT)
  App Server->>Auth Server: Fetch public key (JWKS)
  Auth Server->>App Server: Public key
  App Server->>Client: 200 OK (valid token)
  ```

  ---

  ### 🌊 Flowchart Example:

  ```mermaid
  flowchart TD
      A[Start 🟢] --> B{Is it halal? 🕌}
      B -- Yes --> C[Proceed 🤲]
      B -- No --> D[Run away! 🏃‍♂️💨]
      C --> E[Success ✅]
      D --> E
  ```

  ---

  ### 🧊 State Diagram:

  ```mermaid
  stateDiagram-v2
      [*] --> Idle
      Idle --> Loading : click
      Loading --> Success : loaded
      Loading --> Error : failed
      Error --> Idle : retry
      Success --> [*]
  ```
  
  ### Seq Diag w/ if else
  ```mermaid
  sequenceDiagram
    User->>Client: Request protected resource
    Client->>Server: GET /resource
    Server-->>Client: 200 OK, CSRF token
    Client->>User: Display form with CSRF token
    User->>Client: Submit form
    Client->>Server: POST /resource with CSRF token
    Server->>Database: Verify CSRF token
    alt Token valid
        Database-->>Server: Token valid
        Server->>Database: Process request
        Database-->>Server: 200 OK
        Server-->>Client: 200 OK
        Client->>User: Display result
    else Token invalid
        Database-->>Server: Token invalid
        Server-->>Client: 403 Forbidden
        Client->>User: Display error
    end```
