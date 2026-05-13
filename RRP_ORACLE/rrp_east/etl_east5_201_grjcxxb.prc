CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_201_GRJCXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
   **  存储过程详细说明：个人基础信息表
   **  存储过程名称:  ETL_EAST5_201_GRJCXXB
   **  存储过程创建日期:2022-03-07
   **  存储过程创建人:蔡正伟

   **  输入参数:   I_P_DATE
   **  输出参数:   O_ERRCODE
   **  返回值:     O_ERRCODE
   **  修改日期   修改人       修改原因
   **  20220424   蔡正伟       修改主表与EAST5_KHXXB 关联条件，增加索引，提高效率
   **  20220506   付善斌       修改地址为空问题
   **  20220506   付善斌       国籍字段变动
   **  20220524   付善斌       填报机构源调整
   **  20220530   付善斌       客户名称有特殊字符
   **  20220601   付善斌       归属机构逻辑添加
   **  20220611   付善斌       首次信日期
   **  20220611   付善斌       换行字符替换
   **  20220628   LIP          修改日志记录格式，修改字段超长、字段换行问题
   **  20260316   LIP          个人的只分个体工商户、小微企业主和其他3类，境外客户默认没有
 ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_201_GRJCXXB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_201_GRJCXXB'; --存储过程名称
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
    V_STEP_DESC := '插入个人基础信息表';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_201_GRJCXXB(
      RID,            --数据主键
      JRXKZH,         --金融许可证号
      NBJGH,          --内部机构号
      YHJGMC,         --银行机构名称
      KHTYBH,         --客户统一编号
      KHXM,           --客户姓名
      ZJLB,           --证件类别
      ZJHM,           --证件号码
      BXYGBZ,         --客户类型
      --GJ,             --国籍
      GJHDQ,          --国家或地区
      MZ,             --民族
      XB,             --性别
      XL,             --学历
      CSNY,           --出生年月
      SFYH,           --是否已婚
      GZDWMC,         --工作单位名称
      GZDWDZ,         --工作单位地址
      GZDWDH,         --工作单位电话
      DWXZ,           --单位性质
      ZY,             --职业
      ZW,             --职务
      GRNSR,          --个人年收入
      TXDZ,           --通讯地址
      LXDH,           --联系电话
      XDKHBZ,         --信贷客户标志
      SCJLXDGXNY,     --首次建立信贷关系年月
      SFNH,           --是否农户
      BHYGBZ,         --本行员工标志
      SHMDBZ,         --上黑名单标志
      SHMDRQ,         --上黑名单日期
      BBZ,            --备注
      CJRQ,           --采集日期
      DEPT_NO,        --部门编号
      SRC_SYS_ID,     --来源系统ID
      ISSUED_NO,      --填报机构
      ORG_NO,         --报送机构
      ADDRESS,        --归属地
      KHXM_ORIG,      --客户姓名（脱敏前）
      ZJHM_ORIG,      --证件号码（脱敏前）
      LXDH_ORIG,      --联系电话（脱敏前）
      GSFZJG          --归属分支机构
      )
    SELECT /*+USE_HASH(A,KHXXB,B,CODE,CODE1,CODE2,CODE3,CODE4,CODE5,CODE6,CODE7,CODE8,CODE9,CODE10,ORG,LIST)*/
           SYS_GUID()                                                     AS RID, --数据主键
           B.FIN_PERMIT_NO                                                AS JRXKZH, --金融许可证号
           B.ORG_ID                                                       AS NBJGH, --内部机构号
           B.ORG_NM                                                       AS YHJGMC, --银行机构名称
           A.CUST_ID                                                      AS KHTYBH, --客户统一编号
           --TRIM(A.CUST_NM)                                                AS KHXM, --客户姓名
           A.CUST_NM_DESEN                                               AS KHXM, --客户姓名 --MODIFY BY LAIHAIQIANG AT 20230403
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))                       AS ZJLB, --证件类别 --MODIFY BY LIP 20220629
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))                       AS ZJLB, --证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           A.CRDL_NO_DESEN                                               AS ZJHM,--证件号码 --MODIFY BY LAIHAIQIANG AT 20230403
           CASE --WHEN A.RSDNT_FLG = 'N' THEN '境外客户' --MOD BY LIP 20260316 根据业务要求调整，个人不区分境外客户
                WHEN A.OPR_CUST_TYP = 'A' THEN '个体工商户'
                WHEN A.OPR_CUST_TYP = 'B' THEN '小微企业主'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE10.TAR_VALUE_NAME,'其他-',''),1,40))
                --答疑三的码值：客户类型非空时应填报普通个人客户，个体工商户，小微企业主，境外客户，其他-XX
                --MOD BY LIP 20221123 咨询张家伟后，将除了是境外客户，个体工商户，小微企业主的，都报送为普通个人客户
                ELSE '普通个人客户'
            END                                                          AS BXYGBZ, --客户类型
           --CODE1.TAR_VALUE_NAME                                          AS GJ, --国籍
           CODE1.TAR_VALUE_NAME                                          AS GJHDQ, --国家或地区
           CODE2.TAR_VALUE_NAME                                          AS MZ, --民族
           CODE3.TAR_VALUE_NAME                                          AS XB, --性别
           CODE4.TAR_VALUE_NAME                                          AS XL, --学历
           --SUBSTR(A.BIRTH_DT,1,6)                                        AS CSNY, --出生年月
           /*NVL(SUBSTR(A.BIRTH_DT,1,6),'999912')                          AS CSNY, --出生年月 --MODIFY BY LIP 20220629*/
           CASE WHEN NVL(SUBSTR(A.BIRTH_DT,1,6),'999912') = '000101' THEN '999912'
                ELSE NVL(SUBSTR(A.BIRTH_DT,1,6),'999912')
            END                                                          AS CSNY, --出生年月 modify by tangan at 20230112
           CASE WHEN A.MARRIAGE_STAT LIKE '02%' THEN '是'
                ELSE '否'
            END                                                          AS SFYH, --是否已婚
           --A.CO_NM                                                       AS GZDWMC, --工作单位名称
           --A.CO_ADDR                                                     AS GZDWDZ, --工作单位地址
           REPLACE(REPLACE(TRIM(A.CO_NM),CHR(10),''),CHR(13),'')         AS GZDWMC, --工作单位名称
           REPLACE(REPLACE(TRIM(A.CO_ADDR),CHR(10),''),CHR(13),'')       AS GZDWDZ, --工作单位地址
           TRIM(A.CO_TEL)                                                AS GZDWDH, --工作单位电话
           /*TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40))                      AS DWXZ, --单位性质
           TRIM(SUBSTRB(CODE6.TAR_VALUE_NAME,1,60))                      AS ZY, --职业*/
           TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60))                      AS DWXZ, --单位性质 --MODIFY BY LIP 20240409 改为UTF-8的长度
           TRIM(SUBSTRB(CODE6.TAR_VALUE_NAME,1,90))                      AS ZY, --职业 --MODIFY BY LIP 20240409 改为UTF-8的长度
           TRIM(CODE11.TAR_VALUE_NAME)                                   AS ZW, --职务
           A.IND_YEAR_INCOME                                             AS GRNSR, --个人年收入
           --A.CRDL_ADDR                                                   AS TXDZ, --通讯地址
           --NVL(TRIM(A.RSDNC_ADDR),A.CRDL_ADDR)                           AS TXDZ,  --NVL(居住地址，证件地址)
           REPLACE(REPLACE(NVL(TRIM(A.RSDNC_ADDR),TRIM(A.CRDL_ADDR)),CHR(10),''),CHR(13),'') AS TXDZ,--通讯地址
           A.PHONE_NUM_DESEN                                             AS LXDH, --联系电话
           CASE WHEN TRIM(A.FIRST_ESTBL_CRDT_REL_DT) IS NOT NULL THEN '是'
                ELSE '否'
            END                                                          AS XDKHBZ, --信贷客户标志
           CASE WHEN TRIM(A.FIRST_ESTBL_CRDT_REL_DT) IS NULL THEN '999912'
                ELSE SUBSTR(A.FIRST_ESTBL_CRDT_REL_DT,1,6)
            END                                                          AS SCJLXDGXNY, --首次建立信贷关系年月
           --CODE7.TAR_VALUE_NAME                                          AS SFNH, --是否农户
           --CODE8.TAR_VALUE_NAME                                          AS BHYGBZ, --本行员工标志
           --CODE9.TAR_VALUE_NAME                                          AS SHMDBZ, --上黑名单标志
           NVL(CODE7.TAR_VALUE_NAME,'否')                                AS SFNH, --是否农户
           NVL(CODE8.TAR_VALUE_NAME,'否')                                AS BHYGBZ, --本行员工标志
           NVL(CODE9.TAR_VALUE_NAME,'否')                                AS SHMDBZ, --上黑名单标志
           NVL(A.BLIST_DT,'99991231')                                    AS SHMDRQ, --上黑名单日期
           ''                                                            AS BBZ, --备注
           V_MONTH_END_DATEID                                            AS CJRQ, --采集日期
           '000'                                                         AS DEPT_NO, --部门编号
           '01'                                                          AS SRC_SYS_ID, --来源系统ID
           '000000'                                                      AS ISSUED_NO, --填报机构
           '000000'                                                      AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                          AS ADDRESS, --归属地
           A.CUST_NM                                                     AS KHXM_ORIG, --客户姓名（脱敏前）
           A.CRDL_NO                                                     AS ZJHM_ORIG, --证件号码（脱敏前）
           TRIM(A.PHONE_NUM)                                             AS LXDH_ORIG, --联系电话（脱敏前）
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                          AS GSFZJG --归属分支机构 --MODIFY BY LIP
      FROM RRP_EAST.M_CUST_IND_INFO_EAST A --个人基础信息表
     INNER JOIN RRP_EAST.EAST5_KHXXB KHXXB --通过客户同意编号和证件号码限制有业务数据客户
        ON KHXXB.KHTYBH = A.CUST_ID
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.CTRY_CD
       AND CODE1.SRC_CLASS_CODE = 'P0001' --国家代码
       AND CODE1.TAR_CLASS_CODE = 'P0001' --国家代码
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.ETHNIC
       AND CODE2.SRC_CLASS_CODE = 'C0002' --民族
       AND CODE2.TAR_CLASS_CODE = 'C0002' --民族
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.GENDER
       AND CODE3.SRC_CLASS_CODE = 'C0009' --性别
       AND CODE3.TAR_CLASS_CODE = 'C0009' --性别
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.HIGH_DEGREE
       AND CODE4.SRC_CLASS_CODE = 'C0011' --学历
       AND CODE4.TAR_CLASS_CODE = 'C0011' --学历
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE5 --码值配置表
        ON CODE5.SRC_VALUE_CODE = A.CO_CHAR
       AND CODE5.SRC_CLASS_CODE = 'C0050' --单位性质
       AND CODE5.TAR_CLASS_CODE = 'C0050' --单位性质
       AND CODE5.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE6 --码值配置表
        ON CODE6.SRC_VALUE_CODE = A.OCCUP
       AND CODE6.SRC_CLASS_CODE = 'C0012' --职业
       AND CODE6.TAR_CLASS_CODE = 'C0012' --职业
       AND CODE6.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE11 --码值配置表
        ON CODE11.SRC_VALUE_CODE = A.JOB
       AND CODE11.SRC_CLASS_CODE = 'CD1517' --职务
       AND CODE11.TAR_CLASS_CODE = 'CD1517' --职务
       AND CODE11.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE7 --码值配置表
        ON CODE7.SRC_VALUE_CODE = A.FARM_FLG
       AND CODE7.SRC_CLASS_CODE = 'Z0001' --是否农户
       AND CODE7.TAR_CLASS_CODE = 'Z0001' --是否农户
       AND CODE7.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE8 --码值配置表
        ON CODE8.SRC_VALUE_CODE = A.BANK_EMP_FLG
       AND CODE8.SRC_CLASS_CODE = 'Z0001' --本行员工标志
       AND CODE8.TAR_CLASS_CODE = 'Z0001' --本行员工标志
       AND CODE8.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE9 --码值配置表
        ON CODE9.SRC_VALUE_CODE = A.BLIST_FLG
       AND CODE9.SRC_CLASS_CODE = 'Z0001' --上黑名单标志
       AND CODE9.TAR_CLASS_CODE = 'Z0001' --上黑名单标志
       AND CODE9.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE10 --码值配置表
        ON CODE10.SRC_VALUE_CODE = A.OPR_CUST_TYP
       AND CODE10.SRC_CLASS_CODE = 'C0015' --客户类型
       AND CODE10.TAR_CLASS_CODE = 'C0015' --客户类型
       AND CODE10.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.GENDER IN ('1','2') --暂时剔除未知性别数据
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
    SELECT CJRQ,KHTYBH,COUNT(1)
      FROM RRP_EAST.EAST5_201_GRJCXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,KHTYBH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_201_GRJCXXB(CJRQ,KHTYBH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PARTITION_NAME, O_ERRCODE);

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

END ETL_EAST5_201_GRJCXXB;
/

