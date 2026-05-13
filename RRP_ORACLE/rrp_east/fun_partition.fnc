CREATE OR REPLACE FUNCTION RRP_EAST.FUN_PARTITION(I_DATADATE       IN INTEGER, --跑批日期
                                         I_TABLE_NAME     IN VARCHAR2, --表名称
                                         I_ADD_VALUE_TYPE IN INTEGER) --分区值类型 1：CHAR(8) 2:VARCHAR2(10) 3:DATE
  RETURN INTEGER IS
  /***********************************************************************
  ************************************************************************
    **  存储过程详细说明：获取建分区是否成功标志
    **  存储过程名称:  FUN_PARTITION
    **  存储过程创建日期:2022-04-13
    **  存储过程创建人:李萍
    **  调用方法:
         DECLARE
           I_DATADATE INTEGER;
           O_ERRCODE  CHAR(5);
         BEGIN
           I_DATADATE := '20220101';
           FUN_PARTITION(I_DATADATE, I_TABLE_NAME,I_ADD_VALUE_TYPE);
         END;
    **  输入参数:   I_DATADATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **
    ************************************************************************
  ***********************************************************************/
  V_RESULT            VARCHAR2(10); --输出结果
  O_ERRCODE           VARCHAR2(10);
BEGIN

  ETL_PARTITION_DROP(I_DATADATE, I_TABLE_NAME, O_ERRCODE);
  ETL_PARTITION_ADD(I_DATADATE, I_TABLE_NAME,I_ADD_VALUE_TYPE, O_ERRCODE);

  V_RESULT := 0;
  RETURN V_RESULT;
EXCEPTION
  WHEN OTHERS THEN
   V_RESULT := 1;
   RETURN(V_RESULT);
END;
/

