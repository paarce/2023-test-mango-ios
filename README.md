
# MangoMarvelApp

Short application to visualize and interact with Comics the marvel.

## Extras
- Infitiny scroll
- Unit Tests in all the layer and possible components
- Multilanguage (EN and ES)
- Pull refresh

## Observations
- The model stays as Codable because in some test suites, it was need to convert them to Data with mock data
- Not all the components are tested because the idea was to show how I approached each layer/component

## Folders
    Assets: Resources used to standardize the app user interface
    Core: The fundametals of the app
    Helper: Methods and extension to help some sfeatures inside the app
    Modules: All the modules and its components
    Services: Services for accessing both remote and local data
