CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TD_NETIS_TQ2(I_P_DATE IN INTEGER,
                                               O_ERRCODE  OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_M_TD_NETIS_TQ2
  *  功能描述：TQ2-天旦数据明细表
  *  描述信息： 天旦数据明细
  *  创建日期：20230616
  *  开发人员：xiemeiyi
  *  来源表：  O_TD_NETIS_TQ2
               MRPT_TD_SPVCAP
  *  目标表：  RRP_MDL.M_TD_NETIS_TQ2  --天旦数据明细表
  *
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230710  yangwx     修改succ_rate为rr_rate
  ***************************************************************************/
AS
  -- 定义变量 --
  --XZY 这里要注意，不用他们的规则，用我们自己的规则，变量前一个字母是字段类型的首字母，方便看类型，比如INTEGER类型就用I_开头，VARCHAR2就用V_开头
  --XZY 这部分基本照抄，开发完成后再把不需要的去掉
  I_STEP      INTEGER := 0;        --处理步骤
  I_SQLCOUNT  INTEGER := 0;        --更新或删除影响的记录数
  D_STARTTIME DATE;                --处理开始时间
  D_ENDTIME   DATE;                --处理结束时间
  V_STEP_DESC VARCHAR2(100);       --处理步骤描述
  V_P_DATE    VARCHAR2(8);         --跑批数据日期
  --D_P_DATE    DATE;                --ETL数据日期
  V_SQLMSG    VARCHAR2(300);       --SQL执行描述信息
  V_SQL       VARCHAR2(2000);      --动态SQL
  D_UNIX_DATE DATE;                --UNIX绝对时间
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TD_NETIS_TQ2'; --程序名称 --XZY 新建一个的时候，批量替换成新的名字就行
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  --D_P_DATE := TO_DATE(V_P_DATE,'YYYY-MM-DD');
  D_UNIX_DATE := TO_DATE('19700101','YYYY-MM-DD');

  /*-- 支持重跑 --
  I_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_TD_NETIS_TQ2 T WHERE T.ODS_SRC_DT  = V_P_DATE; --普通表的重跑处理
  \*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_MRPT_BANK_INTER_TRAN_D'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*\
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

  --删除M层表当天数据，支持重跑
  I_STEP      := 2;
  V_STEP_DESC := '-- 删除当天数据 --';
  D_STARTTIME := SYSDATE;
  V_SQL := 'DELETE FROM RRP_MDL.M_TD_NETIS_TQ2 WHERE ODS_SRC_DT =  ''' || V_P_DATE||'''';
  EXECUTE IMMEDIATE V_SQL;
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 3;
  V_STEP_DESC := '插入M_TD_NETIS_TQ2天旦数据明细';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_TD_NETIS_TQ2
    (  ODS_SRC_DT   --跑批日期
      ,ODS_LOAD_DT  --装数时间
      ,SYS_CD       --来源系统
      ,TRANS_DT     --交易日期
      ,TS           --UNIX绝对日期
      ,SPV          --天旦路径图
      ,CAP          --节点编号
      ,TRANS_COUNT  --对应交易量
      ,DURATION     --响应时间
      ,SUCC_CN      --成功笔数
      ,SUCC_RATE    --成功率
      ,RR_RATE      --响应率
      ,SYS_NAME     --对应节点名称
      ,TRANS_TIME   --交易日期
    )
  SELECT  V_P_DATE                             AS ODS_SRC_DT  --跑批日期
         ,TO_CHAR(SYSTIMESTAMP,'YYYY-MM-DD HH24:MI:SS FF') AS ODS_LOAD_DT --装数时间
         ,'TD'                                 AS SYS_CD      --来源系统，天旦
         --TO_CHAR(D_UNIX_DATE+A.TS/86400+,'YYYYMMDD') AS TRANS_DT,    --交易日期 
         ,TO_CHAR(D_UNIX_DATE+A.TS/86400+28800/86400,'YYYYMMDD') AS TRANS_DT    --交易日期   MODIFY XMY 20231106
         ,A.TS                                 AS TS          --UNIX绝对日期
         ,A.SPV                                AS SPV         --天旦路径图
         ,A.CAP                                AS CAP         --节点编号
         ,A.TRANS_COUNT                        AS TRANS_COUNT --对应交易量
         ,A.DURATION                           AS DURATION    --响应时间
         ,ROUND(A.TRANS_COUNT*A.RR_RATE/100,1) AS SUCC_CN     --成功笔数
         ,A.SUCC_RATE                          AS SUCC_RATE   --成功率
         ,A.RR_RATE                            AS RR_RATE     --响应率
         ,B.SYS_NAME                           AS SYS_NAME    --对应节点名称
         ,TO_CHAR(D_UNIX_DATE+A.TS/86400+28800/86400,'YYYY-MM-DD HH24:MI:SS') AS TRANS_TIME --交易日期  MODIFY XMY 20231106
    FROM RRP_MDL.O_TD_NETIS_TQ2 A
    LEFT JOIN RRP_MDL.MRPT_TD_SPVCAP B --静态配置表，各个节点对应的系统名称
      ON B.SPV = A.SPV
     AND B.CAP = A.CAP;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := SQLCODE;
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -------以下代码直接复制---------
  --程序结束标记
  I_STEP      := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    D_ENDTIME   := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_TD_NETIS_TQ2;
/

