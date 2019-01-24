module Homebrew
  class FormulaLoader
    def self.load_formulas(name)
      formula = Formulary.factory(name)
      result = [formula.name]
      result += get_deps(formula, [])
      result
    end

    private_class_method def self.get_deps(formula, result = [])
      formula.deps.each do |dependency|
        dep = Formulary.factory(dependency.name)
        result << dep.name
        get_deps(dep, result)
      end
      result
    end
  end
end
