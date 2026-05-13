CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_1001_HLXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_1001_HLXXB
  *  功能描述：汇率信息表
  *  创建日期：20220713
  *  开发人员：郑经超
  *  来源表： M_PUM_EXRT_INFO         汇率表
              M_PUM_ORG_INFO          机构表
              CONFIG_CODE             码值配置表
              CONFIG_ORG_REL          机构级次关系表
              CONFIG_TABLE_LIST LIST  分行报送报表配置表
  *  目标表： EAST5_1001_HLXXB        汇率信息表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *
  ***************************************************************************/
AS
  --定义变量
  V_P_DATE     VARCHAR2(8);          --跑批数据日期
  V_STEP_DESC  VARCHAR2(100);        --处理步骤描述
  V_SQLCOUNT   INTEGER := 0;         --更新或删除影响的记录数
  V_STEP       INTEGER := 0;         --处理步骤
  V_STARTTIME  DATE := SYSDATE;      --处理开始时间
  V_ENDTIME    DATE := SYSDATE;      --处理结束时间
  V_SQLMSG     VARCHAR2(300);        --SQL执行描述信息
  V_LAST_DAT   VARCHAR2(8);          --当月月末
  V_START_DT   VARCHAR2(8);          --当月月初
  V_PART_NAME  VARCHAR2(100);        --分区名
  V_FREQ_FLAG  VARCHAR2(10);         --跑批频度
  V_TABLE_NAME VARCHAR2(100) := UPPER('EAST5_1001_HLXXB'); --表名称
  V_PROC_NAME  VARCHAR2(30) := UPPER('ETL_EAST5_1001_HLXXB'); --程序名称
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE    := TO_CHAR(I_P_DATE); --获取跑批日期
  V_LAST_DAT  := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_START_DT  := SUBSTR(V_P_DATE,0,6) || '01'; --当月月初
  V_PART_NAME := 'PARTITION_'|| V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(V_P_DATE,V_PROC_NAME); --跑批频度判断
  O_ERRCODE   := '0';

  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    --增加表分区及重跑逻辑,在插入目标报表数据逻辑之前添加这段逻辑
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '分区处理';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);--增加分区 1数据日期为'YYYYMMDD'，2数据日期为'YYYY-MM-DD'
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1001_HLXXB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      WBSL,        --外币数量
      WBBZ,        --外币币种
      BBBZ,        --本币币种
      ZBBSL,       --折本币数量
      HLRQ,        --汇率日期
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG       --归属分支机构
      )
    SELECT SYS_GUID()                                          AS RID,         --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH,      --金融许可证号
           B.ORG_ID                                            AS NBJGH,       --内部机构号
           B.ORG_NM                                            AS YHJGMC,      --银行机构名称
           100                                                 AS WBSL,        --外币数量
           A.BASE_CUR                                          AS WBBZ,        --外币币种
           A.CNV_CUR                                           AS BBBZ,        --本币币种
           A.MDL_PRC                                           AS ZBBSL,       --折本币数量
           A.DATA_DT                                           AS HLRQ,        --汇率日期 --MODIFY BY LIP
           ''                                                  AS BBZ,         --备注
           V_LAST_DAT                                          AS CJRQ,        --采集日期
           '000'                                               AS DEPT_NO,     --部门编号
           '01'                                                AS SRC_SYS_ID,  --来源系统ID
           '000000'                                            AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS,     --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG       --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_PUM_EXRT_INFO A --汇率表
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(A.ORG_ID,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.CNV_CUR = 'CNY'
       --AND A.DATA_DT = V_P_DATE
       AND A.BASE_CUR <> 'CNY' --MODIFY BY XIEYUGENG 20220630 剔除模型明细层添加的人民币折人民币
       AND A.DATA_DT <= V_P_DATE --MODIFY BY LIP
       AND A.DATA_DT >= V_START_DT;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PART_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_1001_HLXXB;
/

