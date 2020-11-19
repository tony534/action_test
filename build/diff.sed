/^$/d
/force-app/{
  s|lwc/(.+)/(.+)|lwc/\1/|
  s|aura/(.+)/(.+)|aura/\1/|
  s|-meta\.xml||
  s|$|\*|p
}