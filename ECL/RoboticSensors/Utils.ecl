import RoboticSensors;
import PBblas.Internal.Types as iTypes;
import PBblas.Types as pTypes;
dimension_t := pTypes.dimension_t;

EXPORT Utils := MODULE
	EXPORT SET OF INTEGER1 castToByteArray(DATA content) := BEGINC++
		__lenResult = lenContent;
		__isAllResult = false;
		
		int8_t *toReturn = (int8_t *) rtlMalloc(__lenResult);
		int8_t *input = (int8_t *) content;
		
		for(size32_t i = 0; i < (size32_t) lenContent; i++){
			toReturn[i] = input[i];
		}
		__result = (void *) toReturn;
	ENDC++;
	
	EXPORT SET OF REAL4 castToFloatArray(DATA content) := BEGINC++
		__lenResult = lenContent;
		__isAllResult = false;
		
		float *toReturn = (float *) rtlMalloc(__lenResult);
		float *input = (float *) content;
		
		for(size32_t i = 0; i < (size32_t) lenContent / 4; i++){
			toReturn[i] = input[i];
		}
		__result = (void *) toReturn;
	ENDC++;

	EXPORT SET OF REAL castToDoubleArray(DATA content) := BEGINC++
		__lenResult = lenContent;
		__isAllResult = false;
		
		double *toReturn = (double *) rtlMalloc(__lenResult);
		double *input = (double *) content;
		
		for(size32_t i = 0; i < (size32_t) lenContent / 4; i++){
			toReturn[i] = input[i];
		}
		__result = (void *) toReturn;
	ENDC++;

	EXPORT iTypes.matrix_t floatToMatrix(dimension_t num_rows, dimension_t num_cols,
																DATA content) := BEGINC++
		__lenResult = sizeof(double) * num_rows * num_cols;
		__isAllResult = false;
		
		double *toReturn = (double *) rtlMalloc(__lenResult);
		float *input = (float *) content; // Reinterpret void* as a float array
		// The data is currrently in row-major order, matrix_t uses column major order
		// In essence, this just transposes the input matrix
		for(size32_t i = 0; i < num_rows; i++){
			for(size32_t j = 0; j < num_cols; j++){
				toReturn[num_rows * j + i] = (double) input[num_cols * i + j];
			}
		}
		__result = (void *) toReturn;
	ENDC++;
	
	EXPORT iTypes.matrix_t doubleToMatrix(dimension_t num_rows, dimension_t num_cols,
																DATA content) := BEGINC++
		__lenResult = sizeof(double) * num_rows * num_cols;
		__isAllResult = false;
		
		double *toReturn = (double *) rtlMalloc(__lenResult);
		double *input = (double *) content; // Reinterpret void* as a float array
		// The data is currrently in row-major order, matrix_t uses column major order
		// In essence, this just transposes the input matrix
		for(size32_t i = 0; i < num_rows; i++){
			for(size32_t j = 0; j < num_cols; j++){
				toReturn[num_rows * j + i] = input[num_cols * i + j];
			}
		}
		__result = (void *) toReturn;
	ENDC++;
	
	EXPORT STRING toString(DATA content) := BEGINC++
		__lenResult = lenContent;
		char *source = (char *) content;
		char *toReturn = (char *) rtlMalloc(lenContent);
		for(unsigned int i = 0; i < lenContent; i++){
			toReturn[i] = *(source + i);
		}
		__result = toReturn;
	ENDC++;
END;