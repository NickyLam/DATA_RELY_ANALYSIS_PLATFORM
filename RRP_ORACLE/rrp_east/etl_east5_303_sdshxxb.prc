CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_303_SDSHXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：收单商户信息表
  **  存储过程名称:  ETL_EAST5_303_SDSHXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改人       修改原因
  **  20220629     LIP          调整格式、修改字段超长、字段换行问题
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_303_SDSHXXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_303_SDSHXXB'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_303_SDSHXXB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      SHBH,        --商户编号
      SHMC,        --商户名称
      SFPOS,       --是否POS商户
      ZDH,         --终端号
      SHMCCM,      --商户MCC码
      SHMCCMC,     --商户MCC名称
      SHDQ,        --商户地区
      QSZH,        --清算账号
      QSZHLX,      --清算账号类型
      QSZHMC,      --清算账户名称
      QSZHKHHMC,   --清算账号开户行名称
      QXRQ,        --起效日期
      SXRQ,        --失效日期
      SHZT,        --商户状态
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      QSZHMC_OTH,  --清算账户是否个人账户
      QSZHMC_ORIG, --清算账户名称（脱敏前）
      GSFZJG       --归属分支机构
      )
    SELECT SYS_GUID()                                          AS RID,         --数据主键
           C.FIN_PERMIT_NO                                     AS JRXKZH,      --金融许可证号
           C.ORG_ID                                            AS NBJGH,       --内部机构号
           A.SPCL_MER_ID                                       AS SHBH,        --商户编号
           A.MER_NM                                            AS SHMC,        --商户名称
           /*CASE WHEN B.TML_TYP = 'POS' THEN '是'
                ELSE '否'
            END                                                  AS SFPOS,       --是否POS商户*/
           CASE WHEN A.DATA_SRC = '线下POS商户' THEN '是'
                ELSE '否'
            END                                                AS SFPOS,       --是否POS商户
           CASE WHEN B.TML_TYP = 'B' THEN B.TML_ID
                WHEN A.DATA_SRC = '线下POS商户' THEN A.SPCL_MER_ID
            END                                                AS ZDH,         --终端号
           A.MER_MCC_CD                                        AS SHMCCM,      --商户MCC码
           A.MER_MCC_NM                                        AS SHMCCMC,     --商户MCC名称
           --TRIM(A.MER_RGN_AREA_CD)                             AS SHDQ,        --商户地区
           CODE_PRO.TAR_VALUE_NAME || CODE_CITY.TAR_VALUE_NAME ||
           CASE WHEN TRIM(A.MER_RGN_AREA_CD) <> SUBSTR(TRIM(A.MER_RGN_AREA_CD),1,4)||'00'
                THEN CODE_COUNTY.TAR_VALUE_NAME
            END                                                AS SHDQ,        --商户地区
           A.LIQ_CRD_NO_OR_ACC                                 AS QSZH,        --清算账号
           --TRIM(SUBSTRB(A.LIQ_ACC_TYP,1,40))                   AS QSZHLX,      --清算账号类型
           TRIM(SUBSTRB(A.LIQ_ACC_TYP,1,60))                   AS QSZHLX,      --清算账号类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           A.CLR_ACC_NM                                        AS QSZHMC,      --清算账户名称
           A.LIQ_ACC_OPEN_BANK_NM                              AS QSZHKHHMC,   --清算账号开户行名称
           NVL(A.SIGN_DT, '99991231')                          AS QXRQ,        --起效日期
           NVL(A.CNL_DT, '99991231')                           AS SXRQ,        --失效日期
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))             AS SHZT,        --商户状态--MODIFY BY LIP
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))             AS SHZT,        --商户状态 --MODIFY BY LIP 20240409 改为UTF-8的长度
           ''                                                  AS BBZ,         --备注
           V_MONTH_END_DATEID                                  AS CJRQ,        --采集日期
           '000'                                               AS DEPT_NO,     --部门编号
           '01'                                                AS SRC_SYS_ID,  --来源系统ID
           '000000'                                            AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS,     --归属地
           '否'                                                AS QSZHMC_OTH,  --清算账户是否个人账户
           A.CLR_ACC_NM                                        AS QSZHMC_ORIG, --清算账户名称（脱敏前）
           C.GSFZJG                                            AS GSFZJG       --归属分支机构
      FROM RRP_MDL.M_OTH_SP_MERC_INFO A --特约商户信息
      LEFT JOIN (SELECT B.MER_ID,TML_TYP,TML_ID,
                        ROW_NUMBER() OVER(PARTITION BY MER_ID ORDER BY DATA_DT DESC,TML_ID) RN --MOD BY LIP 202409229
                   FROM RRP_MDL.M_CHAN_TML_INFO B
                  WHERE B.DATA_DT = V_P_DATE) B --终端设备信息
        ON B.MER_ID = A.SPCL_MER_ID
       AND B.RN = 1
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.MER_STAT
       AND CODE.SRC_CLASS_CODE = 'Z0002' --商户状态
       AND CODE.TAR_CLASS_CODE = 'Z0002' --商户状态
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE_PRO --省
        ON CODE_PRO.SRC_VALUE_CODE = SUBSTR(TRIM(A.MER_RGN_AREA_CD),1,2)||'0000'
       AND CODE_PRO.SRC_CLASS_CODE = 'P0002'
       AND CODE_PRO.TAR_CLASS_CODE = 'P0002'
       AND CODE_PRO.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE_CITY --市
        ON CODE_CITY.SRC_VALUE_CODE = SUBSTR(TRIM(A.MER_RGN_AREA_CD),1,4)||'00'
       AND A.MER_RGN_AREA_CD NOT LIKE '%0000'
       AND CODE_CITY.SRC_CLASS_CODE = 'P0002'
       AND CODE_CITY.TAR_CLASS_CODE = 'P0002'
       AND CODE_CITY.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE_COUNTY --县
        ON CODE_COUNTY.SRC_VALUE_CODE = TRIM(A.MER_RGN_AREA_CD)
       AND CODE_COUNTY.SRC_CLASS_CODE = 'P0002'
       AND CODE_COUNTY.TAR_CLASS_CODE = 'P0002'
       AND CODE_COUNTY.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (A.MER_STAT = 'Y'
            OR (A.MER_STAT = 'N' AND A.CNL_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD'))) --ADD BY LIP 20240802
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '备份目标表数据';
    V_STARTTIME := SYSDATE;
    DELETE RRP_EAST.TMP_EAST5_303_SDSHXXB WHERE CJRQ = V_P_DATE;
    COMMIT;
    INSERT INTO RRP_EAST.TMP_EAST5_303_SDSHXXB
    SELECT * FROM RRP_EAST.EAST5_303_SDSHXXB WHERE CJRQ = V_P_DATE;
    COMMIT;
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE); --源系统数据不准确，临时清除数据，待修复

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,SHBH,ZDH,QSZH,COUNT(1)
      FROM RRP_EAST.EAST5_303_SDSHXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,SHBH,ZDH,QSZH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_303_SDSHXXB(CJRQ,SHBH,ZDH,QSZH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
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

END ETL_EAST5_303_SDSHXXB;
/

