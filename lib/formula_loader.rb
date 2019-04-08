module Homebrew
  class FormulaLoader
    def self.load_formulas(name, recurse = false)
      formula = Formulary.factory(name)
      result = [{name: formula.name, homepage: formula.homepage, url: formula.stable.url}]
      if recurse
        result += get_deps(formula, [])
      end
      result
    end

    private_class_method def self.get_deps(formula, result = [])
      formula.deps.each do |dependency|
        dep = Formulary.factory(dependency.name)
        result << {name: dep.name, homepage: dep.homepage, url: dep.stable.url}
        get_deps(dep, result)
      end
      result
    end
  end
end
