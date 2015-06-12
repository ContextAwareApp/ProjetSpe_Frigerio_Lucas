package com.aware.plugin.getData;

import android.content.ContentResolver;
import android.database.Cursor;
import android.os.Environment;
import android.util.Log;

import com.aware.providers.Accelerometer_Provider;
import com.aware.providers.Gyroscope_Provider;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;


/**
 * Created by FRIGERIO Romain LUCAS Thomas (Ensimag, 2A)
 * This class is in charge of retrieving all the data we will feed to our machine learning algorithms
 * from the SQL database (The data is produced by the sensors inside the phone as well as by other plugins)
 *
 * The data will then be pre-processed : the output of this class (saved in a log file) will
 * be ready-to-use data for our machine learning algorithms and directly sent to Octave (for instance).
 */

public class DataHandler {

    private static final int SIZE_DATA = 256;

    /* Checks if external storage is available for read and write */
    private static boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        return Environment.MEDIA_MOUNTED.equals(state);
    }

    private static File getStorageDir(String name) {
        // Get the directory for the user's public pictures directory.
        File file = new File(Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOCUMENTS), name);
        if (!file.mkdirs()) {
            Log.e("LOG", "Directory not created");
        }
        return file;
    }

    public static String getAccelerometerData(ContentResolver resolver, long start, long end) {
        // Test if dir is available
        if (!isExternalStorageWritable())
            return null;

        // Query for data
        Cursor cursor = resolver.query(Accelerometer_Provider.Accelerometer_Data.CONTENT_URI,
                new String[]{Accelerometer_Provider.Accelerometer_Data.VALUES_0, Accelerometer_Provider.Accelerometer_Data.VALUES_1,
                        Accelerometer_Provider.Accelerometer_Data.VALUES_2, Accelerometer_Provider.Accelerometer_Data.TIMESTAMP},
                        Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " between " + start + " AND " + end, null,
                        Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " ASC");

        // Got data ?
        if (!cursor.moveToFirst())
            return null;

        // Data in a string
        String result = "";
        int count = SIZE_DATA;
        do {
            double X = cursor.getDouble(cursor.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_0));
            double Y = cursor.getDouble(cursor.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_1));
            double Z = cursor.getDouble(cursor.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_2));

            result += X + "," + Y + "," + Z + ",\n";
            count--;
        } while (cursor.moveToNext() && count > 0);
        cursor.close();

        // Writing data in a file
        File dir = getStorageDir("Logs");
        File file = new File(dir, "LogAccelerometer.txt");
        try {
            if (!dir.exists())
                dir.createNewFile();
            if (file.exists())
                file.delete();
            file.createNewFile();

            FileOutputStream fOut = new FileOutputStream(file);
            OutputStreamWriter myOutWriter =
                    new OutputStreamWriter(fOut);
            myOutWriter.append(result);
            myOutWriter.close();
            fOut.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static String getGyroscopeData(ContentResolver resolver, long start, long end) {
        // Test if dir is available
        if (!isExternalStorageWritable())
            return null;

        // Query for data
        Cursor cursor = resolver.query(Gyroscope_Provider.Gyroscope_Data.CONTENT_URI,
                new String[]{Gyroscope_Provider.Gyroscope_Data.VALUES_0, Gyroscope_Provider.Gyroscope_Data.VALUES_1, Gyroscope_Provider.Gyroscope_Data.VALUES_2, Gyroscope_Provider.Gyroscope_Data.TIMESTAMP},
                Gyroscope_Provider.Gyroscope_Data.TIMESTAMP + " between " + start + " AND " + end, null, Gyroscope_Provider.Gyroscope_Data.TIMESTAMP + " ASC");

        // Got data ?
        if (!cursor.moveToFirst())
            return null;

        // Data in a string
        String result = "";
        int count = SIZE_DATA;
        do {
            double time = cursor.getDouble(cursor.getColumnIndex(Gyroscope_Provider.Gyroscope_Data.TIMESTAMP));
            double X = cursor.getDouble(cursor.getColumnIndex(Gyroscope_Provider.Gyroscope_Data.VALUES_0));
            double Y = cursor.getDouble(cursor.getColumnIndex(Gyroscope_Provider.Gyroscope_Data.VALUES_1));
            double Z = cursor.getDouble(cursor.getColumnIndex(Gyroscope_Provider.Gyroscope_Data.VALUES_2));

            result += X + "," + Y + "," + Z + ",\n";
            count--;
        } while (cursor.moveToNext() && count > 0);
        cursor.close();

        // Writing data in a file
        File dir = getStorageDir("Logs");
        File file = new File(dir, "LogGyroscope.txt");
        try {
            if (!dir.exists())
                dir.createNewFile();
            if (file.exists())
                file.delete();
            file.createNewFile();

            FileOutputStream fOut = new FileOutputStream(file);
            OutputStreamWriter myOutWriter =
                    new OutputStreamWriter(fOut);
            myOutWriter.append(result);
            myOutWriter.close();
            fOut.close();

        } catch (IOException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static String getData(ContentResolver resolver, long start, long end) {
        // Test if dir is available
        if (!isExternalStorageWritable())
            return "ERROR STORAGE";

        // Query for data
        Cursor cursor1 = resolver.query(Accelerometer_Provider.Accelerometer_Data.CONTENT_URI,
                new String[]{Accelerometer_Provider.Accelerometer_Data.VALUES_0, Accelerometer_Provider.Accelerometer_Data.VALUES_1, Accelerometer_Provider.Accelerometer_Data.VALUES_2, Accelerometer_Provider.Accelerometer_Data.TIMESTAMP},
                Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " between " + start + " AND " + end, null, Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " ASC");

        // Got data ?
        if (!cursor1.moveToFirst())
            return "NO DATA";

        // Data in a string
        String result = "";
        int count = SIZE_DATA;
        do {
            double X1 = cursor1.getDouble(cursor1.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_0));
            double Y1 = cursor1.getDouble(cursor1.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_1));
            double Z1 = cursor1.getDouble(cursor1.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_2));

            result += X1 + "," + Y1 + "," + Z1 + ",";
            count--;
        } while (cursor1.moveToNext() && count > 0);
        result += "\n";

        if (count != 0) {
            if (cursor1.isAfterLast()) {
                return "NOT ENOUGH DATA : ACCELEROMETER";
            }
        }
        cursor1.close();

        // Writing data in a file
        File dir = getStorageDir("Logs");
        File file = new File(dir, "LogAll.txt");
        try {
            if (!dir.exists())
                dir.createNewFile();
            if (!file.exists())
                file.createNewFile();

            FileOutputStream fOut = new FileOutputStream(file, true);
            fOut.write(result.getBytes());
            fOut.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return "FILE SAVED";
    }
    public static String getProcessedDataInLog(ContentResolver resolver, long start, long end) {

        // Test if dir is available
        if (!isExternalStorageWritable()) {
            Log.i("Context", "ExternalStorage is not writable");
            return "ERROR STORAGE";
        }

        /* --- Declaring temporal arrays used to store the data
        procduced by the sensors. (can be skipped) --- */

        // Arrays to store the accelerometer data (along 3 dimensions)
        double[] x_series1 = new double[SIZE_DATA], y_series1 = new double[SIZE_DATA],z_series1 = new double[SIZE_DATA];
        // Arrays to store second and third order products of the previous arrays
        double[] xy_series1 = new double[SIZE_DATA], xz_series1= new double[SIZE_DATA] ,
                yz_series1= new double[SIZE_DATA], xyz_series1 = new double[SIZE_DATA];

        /* Query for data in the database storing the results produced by sensors */
        //timeStamps start and end are defined in class ContextCard

        //Query to get data from the accelerometer.
        Cursor cursor1 = resolver.query(Accelerometer_Provider.Accelerometer_Data.CONTENT_URI,
                new String[]{Accelerometer_Provider.Accelerometer_Data.VALUES_0, Accelerometer_Provider.Accelerometer_Data.VALUES_1, Accelerometer_Provider.Accelerometer_Data.VALUES_2, Accelerometer_Provider.Accelerometer_Data.TIMESTAMP},
                Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " between " + start + " AND " + end, null, Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " ASC");

        // Making sure the query returned data
        if (!cursor1.moveToFirst()) {
            Log.i("Context", "No data in the SQL Query");
            return "NO DATA";
        }

        // Use the cursor obtained with the request to fill arrays and strings.
        int count = SIZE_DATA;
        int indice = 0;

        do {
            double X1 = cursor1.getDouble(cursor1.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_0));
            double Y1 = cursor1.getDouble(cursor1.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_1));
            double Z1 = cursor1.getDouble(cursor1.getColumnIndex(Accelerometer_Provider.Accelerometer_Data.VALUES_2));

            //Store result for accelerometer in array.
            x_series1[indice] = X1; y_series1[indice] = Y1; z_series1[indice] = Z1;

            count--;
            indice++;
        } while (cursor1.moveToNext() && count > 0);

        if (count != 0) {
            if (cursor1.isAfterLast()) {
                return "NOT ENOUGH DATA : ACCELEROMETER";
            }
        }
        /*Close the cursors (we no longer need the dataBase)*/
        cursor1.close();

        /*------- Declaring arrays that will store the results of the FFTs.
        They are of the same SIZE_DATA than the temporal arrays they correspond to.
         (Can be skipped)---------------------------------------------------*/
        double[] x_fft1 = new double[SIZE_DATA], y_fft1 = new double[SIZE_DATA], z_fft1 = new double[SIZE_DATA];
        double[] xy_fft1 = new double[SIZE_DATA], xz_fft1 = new double[SIZE_DATA], yz_fft1 = new double[SIZE_DATA],
                xyz_fft1 = new double[SIZE_DATA];

        //Initializing the arrays to 0
        for(int ind = 0; ind < SIZE_DATA ;ind++){
            x_fft1[ind] = 0.0; y_fft1[ind] = 0.0; z_fft1[ind] = 0.0;
            xy_fft1[ind] = 0.0; xz_fft1[ind] = 0.0; yz_fft1[ind] =0.0;
            xyz_fft1[ind] = 0.0;
        }
        /*---------------------------------------------------------------*/

        /* Processing of the data  : PCA*/
        // Class PCA will perform the Principal Component Analysis on the data
        // The goal is to compensate the fact that the phone can be randomly oriented.

        //PCA for the accelerometer
        PCA pca = new PCA(x_series1,y_series1,z_series1);
        double[][] newBase = new double[3][3];
        newBase = pca.determine_PCA();
        double[][] new_coord = new double[SIZE_DATA][3];
        new_coord = pca.changeBase(newBase,x_series1,y_series1,z_series1);

        x_series1 = new_coord[0];
        y_series1 = new_coord[1];
        z_series1 = new_coord[2];

        /* Writing the results in a file */
        String resultSimple = "";
        String resultSummary = "";

        // Coeff of PCA
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                resultSimple += newBase[i][j] + ",";
                resultSummary += newBase[i][j] + ",";
            }
        }

        /* Processing the data : compute second and third order products*/
        /*Log.i("Context"," Nous avons pass� l'initialisation des tableaux");
        for (int k = 0; k < SIZE_DATA; k++) {
            Log.i("Context","Nous sommes entr�s dans la boucle");
            double X1 = x_series1[k]; double Y1 = y_series1[k]; double Z1 = z_series1[k];

            xy_series1[k] = X1 * Y1; xz_series1[k] = X1 * Z1;
            yz_series1[k] = Y1 * Z1; xyz_series1[k] = X1 * Y1 * Z1;
        }
        Log.i("Context","Nous avons pass� le calcul des produits");*/

        /* Processing the data : compute the Discrete fourier transforms */
        //Class FFT will perform the fast fourier transform.
        FFT fft = new FFT(SIZE_DATA);
        Log.i("Context","Nous avons initializ� la FFT");

        /*Computing the FFTs */
        //ffts for the accelerometer

        fft.fft(x_series1,x_fft1); fft.fft(y_series1,y_fft1); fft.fft(z_series1, z_fft1);
        //x_fft1 = x_series1; y_fft1 = y_series1; z_fft1 = z_series1;
        /*fft.fft(xy_series1,xy_fft1);  fft.fft(xz_series1,xz_fft1);  fft.fft(yz_series1,yz_fft1);
        fft.fft(xyz_series1,xyz_fft1);*/
        Log.i("Context","Nous avons pass� le calcul des ffts");

        //Accelerometer
        for(int k = 0; k < SIZE_DATA; k++){
            resultSimple += x_series1[k] + "," + x_fft1[k] + "," ;
            //resultProduct += xy_fft1[k] + "," ;
        }
        for(int k = 0; k < SIZE_DATA; k++){
            resultSimple += y_series1[k] + "," + y_fft1[k] + "," ;
            //resultProduct += xz_fft1[k] + "," ;
        }
        for(int k = 0; k < SIZE_DATA; k++){
            resultSimple += z_series1[k] + "," + z_fft1[k] + "," ;
            //resultProduct += yz_fft1[k] + "," ;
        }
        Log.i("Context","Nous avons constitu� la string � mettre dans les logs");

        for (int i = 0; i < 12; i++) {
            double sumPosX1 = 0; double sumPosY1 = 0; double sumPosZ1 = 0;
            double sumPosX2 = 0; double sumPosY2 = 0; double sumPosZ2 = 0;
            double sumNegX1 = 0; double sumNegY1 = 0; double sumNegZ1 = 0;
            double sumNegX2 = 0; double sumNegY2 = 0; double sumNegZ2 = 0;

            double X1 = 0; double Y1 = 0; double Z1 = 0;
            double X2 = 0; double Y2 = 0; double Z2 = 0;

            for (int k = 0; k < 20; k ++) {
                X1 = x_fft1[i*20 + k]; Y1 = y_fft1[i*20 + k]; Z1 = z_fft1[i*20 + k];
                X2 = x_series1[i*20 + k]; Y2 = y_series1[i*20 + k]; Z2 = z_series1[i*20 + k];

                if (X1 > 0) {
                    sumPosX1 += X1;
                } else {
                    sumNegX1 += X1;
                }
                if (X2 > 0) {
                    sumPosX2 += X2;
                } else {
                    sumNegX2 += X2;
                }

                if (Y1 > 0) {
                    sumPosY1 += Y1;
                } else {
                    sumNegY1 += Y1;
                }
                if (Y2 > 0) {
                    sumPosY2 += Y2;
                } else {
                    sumNegY2 += Y2;
                }

                if (Z1 > 0) {
                    sumPosZ1 += Z1;
                } else {
                    sumNegZ1 += Z1;
                }
                if (Z2 > 0) {
                    sumPosZ2 += Z2;
                } else {
                    sumNegZ2 += Z2;
                }
            }
            resultSummary += sumPosX1 + "," + sumPosX2 + "," + sumNegX1 + "," + sumNegX2 + ","
                    + sumPosY1 + "," + sumPosY2 + "," + sumNegY1 + "," + sumNegY2 + ","
                    + sumPosZ1 + "," + sumPosZ2 + "," + sumNegZ1 + "," + sumNegZ2 + ",";
        }

        // Add summary for each variable
        Summary summaryX1 = new Summary(x_series1);
        Summary summaryY1 = new Summary(y_series1);
        Summary summaryZ1 = new Summary(z_series1);

        Summary summaryX2 = new Summary(x_fft1);
        Summary summaryY2 = new Summary(y_fft1);
        Summary summaryZ2 = new Summary(z_fft1);

        resultSimple += summaryX1.getSummaryString();
        resultSimple += summaryY1.getSummaryString();
        resultSimple += summaryZ1.getSummaryString();
        resultSimple += summaryX2.getSummaryString();
        resultSimple += summaryY2.getSummaryString();
        resultSimple += summaryZ2.getSummaryString();

        resultSummary += summaryX1.getSummaryString();
        resultSummary += summaryY1.getSummaryString();
        resultSummary += summaryZ1.getSummaryString();
        resultSummary += summaryX2.getSummaryString();
        resultSummary += summaryY2.getSummaryString();
        resultSummary += summaryZ2.getSummaryString();

        //Jump a line so that each experiment has it's own
        resultSimple += "\n";
        resultSummary += "\n";

        // Writing data in a file
        File dir = getStorageDir("Logs");
        File fileSimple = new File(dir, "LogSimple.txt");
        File fileSummary = new File(dir, "LogSummary.txt");
        try {
            if (!dir.exists())
                dir.createNewFile();
            if (!fileSimple.exists())
                fileSimple.createNewFile();
            if (!fileSummary.exists())
                fileSummary.createNewFile();

            FileOutputStream simpleStream = new FileOutputStream(fileSimple, true);
            FileOutputStream summaryStream = new FileOutputStream(fileSummary, true);
            simpleStream.write(resultSimple.getBytes());
            summaryStream.write(resultSummary.getBytes());
            simpleStream.close();
            summaryStream.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
        return "FILE SAVED";
    }
}
