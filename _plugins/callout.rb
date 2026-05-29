# frozen_string_literal: true

# Jekyll plugin to transform GitHub-style callouts into styled HTML.
# Supports: [!NOTE], [!TIP], [!IMPORTANT], [!WARNING], [!CAUTION], [!INFO]
#
# Usage in markdown:
#   > [!info] Optional title text
#   > Body text here.

Jekyll::Hooks.register :documents, :pre_render do |doc|
  doc.content = transform_callouts(doc.content)
end

Jekyll::Hooks.register :pages, :pre_render do |page|
  page.content = transform_callouts(page.content)
end

CALLOUT_ICONS = {
  "note"      => "📝",
  "tip"       => "💡",
  "important" => "❗",
  "warning"   => "⚠️",
  "caution"   => "🔥",
  "info"      => "ℹ️"
}.freeze

def transform_callouts(content)
  # Match: > [!type] Optional title
  #        > body lines...
  content.gsub(/^> \[!(#{CALLOUT_ICONS.keys.join("|")})\][ \t]*(.*?)\n((?:>.*\n?)*)/i) do
    type        = Regexp.last_match(1).downcase
    inline_title = Regexp.last_match(2).strip
    body        = Regexp.last_match(3)
    icon        = CALLOUT_ICONS[type]
    title       = inline_title.empty? ? type.capitalize : inline_title

    # Strip leading "> " from each body line
    body_lines = body.gsub(/^> ?/, "").strip

    # Use a <p> for the title (inline element — Kramdown won't mangle it)
    # and a block div with markdown="1" for the body.
    "<div class=\"callout callout-#{type}\">" \
    "<p class=\"callout-title\"><span class=\"callout-icon\">#{icon}</span> #{title}</p>" \
    "<div class=\"callout-body\" markdown=\"block\">\n\n" \
    "#{body_lines}\n\n" \
    "</div></div>\n"
  end
end
