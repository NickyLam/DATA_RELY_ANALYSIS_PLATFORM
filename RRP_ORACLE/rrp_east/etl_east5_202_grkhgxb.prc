CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_202_GRKHGXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：个人客户关系表
  **  存储过程名称:  ETL_EAST5_202_GRKHGXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改人        修改原因
  **  20220424     蔡正伟        修改主表与EAST5_KHXXB 关联条件，增加索引，提高效率
  **  20220524     付善斌        填报机构源调整
  **  20220530     付善斌        关联人名称有特殊字符
  **  20220601     付善斌        归属机构逻辑添加
  **  20220614     付善斌        过滤关联人和客户同名数据
  **  20220614     付善斌        过滤关联人和客户同名数据
  **  20220628     LIP           修改日志记录格式，修改字段超长、字段换行问题
  *************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_202_GRKHGXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_202_GRKHGXB'); --表名称
BEGIN
  O_ERRCODE := '0';
  V_P_DATE  := TO_CHAR(I_P_DATE);
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '个人客户关系表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_202_GRKHGXB(
      RID,          --数据主键
      JRXKZH,       --金融许可证号
      NBJGH,        --内部机构号
      KHTYBH,       --客户统一编号
      KHXM,         --客户姓名
      ZJLB,         --证件类别
      ZJHM,         --证件号码
      GXLX,         --关系类型
      GXRKHTYBH,    --关系人客户统一编号
      GXRMC,        --关系人名称
      GXRZJLB,      --关系人证件类别
      GXZT,         --关系状态
      GXRZJHM,      --关系人证件号码
      BBZ,          --备注
      CJRQ,         --采集日期
      DEPT_NO,      --部门编号
      SRC_SYS_ID,   --来源系统ID
      ISSUED_NO,    --填报机构
      ORG_NO,       --报送机构
      ADDRESS,      --归属地
      GXRMC_ORIG,   --关系人名称（脱敏前）
      GXRZJHM_ORIG, --关系人证件号码（脱敏前）
      KHXM_ORIG,    --客户姓名（脱敏前）
      ZJHM_ORIG,    --证件号码（脱敏前）
      GXRMC_OTH,    --关系人是否个人
      GSFZJG        --归属分支机构
      )
    SELECT /*+USE_HASH(A,KHXXB,B,C,CODE,CODE1,CODE2,CODE3,ORG,LIST)*/
           SYS_GUID()                                                AS RID,          --数据主键
           C.FIN_PERMIT_NO                                           AS JRXKZH,       --金融许可证号
           C.ORG_ID                                                  AS NBJGH,        --内部机构号
           A.CUST_ID                                                 AS KHTYBH,       --客户统一编号
           B.CUST_NM_DESEN                                           AS KHXM,         --客户姓名
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))                   AS ZJLB,         --证件类别
           B.CRDL_NO_DESEN                                           AS ZJHM,         --证件号码
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))                  AS GXLX,         --关系类型
           --A.RELA_PS_ID                                              AS GXRKHTYBH,    --关系人客户统一编号
           NVL(TRIM(A.REL_PSN_CUST_ID),TRIM(A.RELA_PS_ID))           AS GXRKHTYBH,    --关系人客户统一编号 --MOD BY LIP 20260408
           --MOD BY LIP 20240401 对公的不需脱敏
           CASE WHEN A.REL_PSN_CRDL_TYP LIKE '2%' THEN TRIM(A.REL_PSN_NM)
                ELSE TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.REL_PSN_NM,'[[:punct:]]',''),0))
            END                                                      AS GXRMC,        --关系人名称
           --CODE2.TAR_VALUE_NAME                                      AS GXRZJLB,      --关系人证件类别
           TRIM(SUBSTRB(CODE2.TAR_VALUE_NAME,1,40))                  AS GXRZJLB,      --关系人证件类别
           CODE3.TAR_VALUE_NAME                                      AS GXZT,         --关系状态
           CASE WHEN A.REL_PSN_CRDL_TYP LIKE '2%' THEN TRIM(A.REL_PSN_CRDL_NO)
                ELSE --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
                     CASE WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                          WHEN NVL(LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))),0) = 0 THEN '000000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                      END || RRP_EAST.SM3_ENCRYPT((CASE WHEN LENGTH(REGEXP_REPLACE(A.REL_PSN_NM,'[[:punct:]]',''))
                                                          = LENGTHB(REGEXP_REPLACE(A.REL_PSN_NM,'[[:punct:]]',''))
                                                       THEN SUBSTR(REGEXP_REPLACE(A.REL_PSN_NM,'[[:punct:]]',''), 1, 3)
                                                       ELSE SUBSTR(REGEXP_REPLACE(A.REL_PSN_NM,'[[:punct:]]',''), 1, 1)
                                                   END
                     || UPPER(A.REL_PSN_CRDL_NO)))
            END                                                      AS GXRZJHM,      --关系人证件号码
           ''                                                        AS BBZ,          --备注
           V_MONTH_END_DATEID                                        AS CJRQ,         --采集日期
           '000'                                                     AS DEPT_NO,      --部门编号
           '01'                                                      AS SRC_SYS_ID,   --来源系统ID
           '000000'                                                  AS ISSUED_NO,    --填报机构
           ORG.ORG_ID_LEL_0                                          AS ORG_NO,       --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                      AS ADDRESS,      --归属地
           A.REL_PSN_NM                                              AS GXRMC_ORIG,   --关系人名称（脱敏前）
           TRIM(A.REL_PSN_CRDL_NO)                                   AS GXRZJHM_ORIG, --关系人证件号码（脱敏前）
           B.CUST_NM                                                 AS KHXM_ORIG,    --客户姓名（脱敏前）
           B.CRDL_NO                                                 AS ZJHM_ORIG,    --证件号码（脱敏前）
           --'是'                                                      AS GXRMC_OTH,   --关系人是否个人
           --MOD BY LIP 20240401
           CASE WHEN A.REL_PSN_CRDL_TYP LIKE '1%' THEN '是'
                WHEN A.REL_PSN_CRDL_TYP LIKE '2%' THEN '否'
                ELSE '是'
            END                                                      AS GXRMC_OTH,    --关系人是否个人
           C.GSFZJG                                                  AS GSFZJG        --归属分支机构
      FROM RRP_MDL.M_CUST_IND_REL_SUB  A --个人客户关系子表
     INNER JOIN RRP_EAST.EAST5_KHXXB KHXXB --通过客户统一编号和证件号码限制有业务数据客户
        ON KHXXB.KHTYBH = A.CUST_ID
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST B --个人客户信息表
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = B.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类型
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.REL_TYP
       AND CODE1.SRC_CLASS_CODE = 'C0017' --关系类型
       AND CODE1.TAR_CLASS_CODE = 'C0017' --关系类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.REL_PSN_CRDL_TYP
       AND CODE2.SRC_CLASS_CODE = 'C0001' --关系人证件类型
       AND CODE2.TAR_CLASS_CODE = 'C0001' --关系人证件类型
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.REL_STAT
       AND CODE3.SRC_CLASS_CODE = 'Z0002' --关系状态
       AND CODE3.TAR_CLASS_CODE = 'Z0002' --关系状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE NVL(A.REL_PSN_CRDL_NO,' ') <> NVL(B.CRDL_NO,' ') --本人为本人担保的关系不报送
       AND NVL(A.REL_PSN_NM,' ') <> NVL(B.CUST_NM,' ')
       AND A.DATA_DT = V_P_DATE;

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
    SELECT CJRQ,KHTYBH,GXRKHTYBH,GXRZJHM,COUNT(1)
      FROM RRP_EAST.EAST5_202_GRKHGXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,KHTYBH,GXRKHTYBH,GXRZJHM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_202_GRKHGXB(CJRQ,KHTYBH,GXRKHTYBH,GXRZJHM)数据重复';
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

  V_STEP    := V_STEP + 1;
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

END ETL_EAST5_202_GRKHGXB;
/

