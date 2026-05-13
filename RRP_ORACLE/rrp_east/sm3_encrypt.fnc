CREATE OR REPLACE FUNCTION RRP_EAST.SM3_Encrypt (cryptData IN STRING)

   RETURN String DETERMINISTIC

IS

   LANGUAGE JAVA

   NAME 'SM3.Encode(java.lang.String) return String';
/

