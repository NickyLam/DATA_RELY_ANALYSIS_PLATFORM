CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_501_XDHTB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_501_XDHTB
  *  功能描述：信贷合同表
  *  创建日期：2022-03-07
  *  开发人员：蔡正伟
  *  来源表：  M_LOAN_CONT_INFO
  *            M_PUM_ORG_INFO_EAST
  *            M_LOAN_IN_DUBILL_INFO
  *            M_CUST_IND_INFO
  *            M_CUST_CORP_INFO
  *  目标表：  EAST5_501_XDHTB
  *  配置表：  CODE_MAP
  *            CONFIG_ORG_REL
  *            CONFIG_TABLE_LIST
  *  修改日期    修改人      修改项目
  *  20220511    LIP         修改日志写入方式
  *  20221108    LIP         模型不过滤数据，改成应用层过滤月初前结清的数据(暂不过滤)
  *  20230609    LIP         根据张家伟口径，剔除未生效和撤销的合同
  ***************************************************************************/
AS
  V_P_DATE           VARCHAR2(8);    --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);    --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);  --分区名称
  V_FREQ_FLAG        VARCHAR2(10);   --跑批频度
  V_STEP             INTEGER := 0;   --任务号
  V_COUNT            INTEGER := 0;   --数据记录条数
  V_STARTTIME        DATE;           --处理开始时间
  V_ENDTIME          DATE;           --处理结束时间
  V_SQLCOUNT         INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);  --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);  --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_501_XDHTB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_501_XDHTB'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --删除当日分区数据
    V_STEP := 1;
    V_STEP_DESC := '表分区处理';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_ADD(V_MONTH_END_DATEID,V_TABLE_NAME,1,O_ERRCODE); --新建分区

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --支持重跑
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '清空当日分区以便重跑';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_TRUNCATE(V_MONTH_END_DATEID,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '处理信贷合同数据';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_501_XDHTB(
      RID,          --数据主键
      JRXKZH,       --金融许可证号
      NBJGH,        --内部机构号
      KHTYBH,       --客户统一编号
      KHMC,         --客户名称
      XDHTH,        --信贷合同号
      ZHTH,         --主合同号
      HTMC,         --合同名称
      XDYWZL,       --信贷业务种类
      BZ,           --币种
      HTJE,         --合同金额
      HTQSRQ,       --合同起始日期
      HTDQRQ,       --合同到期日期
      DBLX,         --担保类型
      KHJLGH,       --客户经理工号
      HTDKYT,       --合同贷款用途
      HTZT,         --合同状态
      BBZ,          --备注
      CJRQ,         --采集日期
      DEPT_NO,      --部门编号
      SRC_SYS_ID,   --来源系统ID
      ISSUED_NO,    --填报机构
      ORG_NO,       --报送机构
      ADDRESS,      --归属地
      KHMC_ORIG,    --客户名称（脱敏前）
      KHMC_OTH,     --客户是否个人客户
      DKCPMC,       --贷款产品名称 只用来区分行内外产品
      GSFZJG        --归属分支机构
      )
      WITH LOAN_IN_DUBILL_INFO AS (
    SELECT CONT_ID,SYN_LOAN_FLG,PROJ_LOAN_FLG,DATA_DT,LOAN_BIZ_TYP,
           ROW_NUMBER() OVER(PARTITION BY CONT_ID ORDER BY RCPT_ID DESC,DATA_DT DESC) RN
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO DUB
     WHERE EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND DUB.AD_CSH_FLG = '0' --ADD BY LIP 20230620 过滤过路垫款
       AND DATA_DT = V_P_DATE),
     EMP_INFO AS (--更新信贷合同表客户经理工号是中文的数据 --ADD BY LIP 20251105
    SELECT EMP_NM,EMP_ID,ROW_NUMBER() OVER(PARTITION BY EMP_NM ORDER BY
           CASE WHEN EMP_STAT = '1' THEN 1 WHEN EMP_STAT = '2' THEN 2 ELSE 5 END ASC,ASSIGN_DT DESC) RN
      FROM RRP_MDL.M_PUM_EMP_INFO
     WHERE DATA_DT = V_P_DATE)
    SELECT /*+USE_HASH(A,B,C,D,E,CODE,CODE1,CODE2,ORG,LIST)*/
           SYS_GUID()                                              AS RID,          --数据主键
           B.FIN_PERMIT_NO                                         AS JRXKZH,       --金融许可证号
           B.ORG_ID                                                AS NBJGH,        --内部机构号
           A.CUST_ID                                               AS KHTYBH,       --客户统一编号
           --NVL(D.CUST_NM_DESEN,E.CUST_NM)                          AS KHMC,         --客户名称--MODIFY BY LAIHAIQIANG AT 20230403
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN D.CUST_NM_DESEN IS NOT NULL THEN D.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(E.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(E.CUST_NM),'(','（'),')','）'),' ','')
                WHEN E.CUST_NM IS NOT NULL
                THEN E.CUST_NM
            END                                                    AS KHMC,         --客户名称
           A.CONT_ID                                               AS XDHTH,        --信贷合同号
           A.PRIM_CONT_ID                                          AS ZHTH,         --主合同号
           TRIM(REPLACE(REPLACE(A.CONT_NM,CHR(10),''),CHR(13),'')) AS HTMC,         --合同名称
           CASE WHEN A.LOAN_PROD_TYP = '020101' THEN '流动资金贷款' --MOD BY LIP 20241021
                WHEN A.LOAN_PROD_TYP = '0602' THEN '法人账户透支'
                WHEN C.PROJ_LOAN_FLG = 'Y' OR A.STD_PROD_ID = '203010300001' THEN '项目贷款' --20230525 MOD BY LIP 增加并购贷款
                --WHEN C.PROJ_LOAN_FLG = 'Y' THEN '项目贷款'
                WHEN C.SYN_LOAN_FLG = 'Y' THEN '项目贷款（银团）'
                WHEN A.STD_PROD_ID LIKE '60206%' THEN '项目贷款（银团）' --银团贷款-牵头行 银团贷款-我行代管 --ADD BY LIP 20260402
                /*MODIFY BY LIP 20220718因深圳银监对数要求，增加经营性物业贷款的区分标志 按S67口径
                将对公的一般固定资产贷款中的1030050经营性物业贷款 标记为 其他-经营性物业贷款
                将个人的个人经营性贷款中的 0200100300204 个人经营性物业抵押贷款 标记为 其他-经营性物业贷款*/
                WHEN A.LOAN_PROD_TYP IN ('020201','010204') THEN '其他-经营性物业贷款'
                /*MODIFY BY LIP 20240703 因深圳银监对数要求，增加经营性物业贷款的区分标志 按S67口径
                将对公的一般固定资产贷款中的 203010200001 经营性物业贷款 标记为 其他-经营性物业贷款
                将个人的个人经营性贷款中的 201020100048 个人经营性物业抵押贷款 标记为 其他-经营性物业贷款*/
                WHEN A.STD_PROD_ID IN ('203010200001','201020100048') THEN '其他-经营性物业贷款'
                WHEN A.CONT_ID IN ('R20220428001610') THEN '其他-经营性物业贷款'
                WHEN A.LOAN_PROD_TYP LIKE '0202%' THEN '一般固定资产贷款'
                WHEN A.LOAN_PROD_TYP LIKE '0101%' THEN '住房按揭贷款'
                WHEN SUBSTR(A.LOAN_PROD_TYP,1,6) IN ('010201','010203') THEN '商用房贷款'
                --WHEN SUBSTR(A.LOAN_PROD_TYP,1,6) IN ('010202','010301') THEN '汽车贷款'
                WHEN SUBSTR(A.LOAN_PROD_TYP,1,6) IN ('010301') THEN '汽车贷款' --MOD BY LIP 20260407 根据业务口径调整，汽车贷款只包含消费贷款中的购个人用车和购车+车牌
                WHEN A.LOAN_PROD_TYP LIKE '0104%' THEN '助学贷款'
                WHEN A.LOAN_PROD_TYP LIKE '010399%' THEN '消费贷款'
                WHEN A.LOAN_PROD_TYP LIKE '0103%' THEN '消费贷款' --MOD BY LIP 20241021
                --WHEN A.LOAN_PROD_TYP = '010299' THEN '个人经营性贷款'
                WHEN A.LOAN_PROD_TYP IN ('010202','010299') THEN '个人经营性贷款' --MOD BY LIP 20260407 根据业务口径调整，个人经营性贷款“购商用车”的不纳入“汽车贷款”中而是纳入“个人经营性贷款”
                WHEN A.LOAN_PROD_TYP LIKE '0301%' THEN '票据贴现'
                WHEN A.LOAN_PROD_TYP LIKE '030201%' THEN '买断式转贴现'
                --WHEN A.LOAN_PROD_TYP LIKE '0204%' OR A.LOAN_PROD_TYP IN ('0399') THEN '贸易融资业务'
                WHEN A.LOAN_PROD_TYP LIKE '0204%' OR A.STD_PROD_ID IN ('203030600002','203020300002') THEN '贸易融资业务' --MOD BY LIP 20241021
                WHEN A.LOAN_PROD_TYP LIKE '0206%' THEN '融资租赁业务'
                WHEN A.LOAN_PROD_TYP LIKE '0205%' THEN '垫款'
                --WHEN A.LOAN_PROD_TYP LIKE '0201%' THEN '流动资金贷款'
                WHEN A.LOAN_PROD_TYP = '90' THEN '委托贷款' --MODIFY BY LUZM 20221024 A.LOAN_PROD_TYP LIKE '12%'改A.LOAN_PROD_TYP = '90'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME,'其他-',''),1,100))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME,'其他-',''),1,150)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS XDYWZL,       --信贷业务种类
           A.CUR                                                   AS BZ,           --币种
           --NVL(A.CONT_AMT,0)                                       AS HTJE,         --合同金额
           --MOD BY LIP 20240103
           CASE WHEN NVL(A.CONT_AMT,0) <> 0 THEN NVL(A.CONT_AMT,0)
                ELSE NVL(A.ACP_DISTR_AMT,0) --花呗合同金额为0时，用花呗的放款金额字段
            END                                                    AS HTJE,         --合同金额
           NVL(A.CONT_START_DT,'99991231')                         AS HTQSRQ,       --合同起始日期
           NVL(A.CONT_EXP_DT,'99991231')                           AS HTDQRQ,       --合同到期日期
           CASE WHEN A.LOAN_PROD_TYP LIKE '0302%' THEN '其他-承兑行信用'  --MODIFY BY TANGAN AT 20221125 根据填报口径答疑，买断式转贴现填报“其他-承兑行信用”
                WHEN A.LOAN_PROD_TYP LIKE '0301%' OR A.LOAN_PROD_TYP LIKE '030201%' THEN '信用' --MOD LIP 20250210 严希婧：担保类型，如果是贴现、转贴现，默认信用
                WHEN A.MAIN_GUA_MODE = '1' THEN '抵押'
                WHEN A.MAIN_GUA_MODE = '2' THEN '质押'
                WHEN A.MAIN_GUA_MODE LIKE '3' THEN '保证'
                WHEN A.MAIN_GUA_MODE = '5E' THEN '混合'
                WHEN A.MAIN_GUA_MODE = '4' THEN '信用'
                ELSE '其他-其他' --MODIFY BY TANGAN AT 20221125
            END                                                    AS DBLX,         --担保类型
           --TRIM(A.CUST_MGR_NO)                                     AS KHJLGH,       --客户经理工号
           NVL(F.EMP_ID,TRIM(A.CUST_MGR_NO))                       AS KHJLGH,       --客户经理工号 --MOD BY LIP 20251105
           --TRIM(SUBSTRB(REPLACE(REPLACE(A.LOAN_USEAGE,CHR(10),''),CHR(13),''),1,1000)) AS HTDKYT, --合同贷款用途
           TRIM(SUBSTRB(REPLACE(REPLACE(A.LOAN_USEAGE,CHR(10),''),CHR(13),''),1,1500)) AS HTDKYT, --合同贷款用途 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN A.CONT_STAT = '01' THEN '未生效'
                WHEN A.CONT_STAT = '02' THEN '有效'
                WHEN A.CONT_STAT = '06' THEN '撤销'
                WHEN A.CONT_STAT = '07' THEN '终结'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS HTZT,         --合同状态
           ''                                                      AS BBZ,          --备注
           V_MONTH_END_DATEID                                      AS CJRQ,         --采集日期
           '000'                                                   AS DEPT_NO,      --部门编号
           '01'                                                    AS SRC_SYS_ID,   --来源系统ID
           '000000'                                                AS ISSUED_NO,    --填报机构
           '000000'                                                AS ORG_NO,       --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS,      --归属地
           --NVL(D.CUST_NM, E.CUST_NM)                               AS KHMC_ORIG,    --客户名称（脱敏前）
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN D.CUST_NM IS NOT NULL THEN D.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(E.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(E.CUST_NM),'(','（'),')','）'),' ','')
                WHEN E.CUST_NM IS NOT NULL
                THEN E.CUST_NM
            END                                                    AS KHMC_ORIG,    --客户名称（脱敏前）
           CASE WHEN D.CUST_NM IS NOT NULL THEN '是'
                ELSE '否'
            END                                                    AS KHMC_OTH,     --客户是否个人客户
           /*CASE WHEN E.CUST_ID IS NOT NULL THEN '对公贷款'
                WHEN A.LOAN_PROD_NM LIKE '%花呗%' THEN '花呗'
                WHEN A.LOAN_PROD_NM LIKE '%微粒贷%' THEN '微粒贷'
                WHEN A.LOAN_PROD_NM LIKE '%借呗%' THEN '借呗'
                WHEN A.LOAN_PROD_NM LIKE '%京东%' THEN '京东'
                --ADD BY LIP 20230919 将网商贷债权直转的区分出来
                WHEN A.LOAN_PROD_NM LIKE '%债权直转%' THEN A.LOAN_PROD_NM
                WHEN A.LOAN_PROD_NM LIKE '%网商贷%' THEN '网商贷'
                WHEN A.STD_PROD_ID IN ('202020200001') THEN '字节小微贷' --MOD BY LIP 20250115
                WHEN A.STD_PROD_ID IN ('201020100057') THEN '华兴快贷经营' --MOD BY LIP 20250115 房抵贷
                WHEN A.STD_PROD_ID IN ('203050100001') THEN '字节微业贷' --MOD BY LIP 20250310 微业贷
                WHEN A.DATA_SRC LIKE '%联合网贷%' THEN A.LOAN_PROD_NM --MOD BY LIP 20250808
                ELSE '行内自营贷款'
            END                                                    AS DKCPMC,       --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款*/
           A.LOAN_PROD_NM                                          AS DKCPMC,       --贷款产品名称 --MOD BY LIP 20251216 直接展示所有产品名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                    AS GSFZJG        --归属分支机构
      FROM RRP_MDL.M_LOAN_CONT_INFO A --贷款合同表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      --INNER JOIN LOAN_IN_DUBILL_INFO C --表内借据信息
      LEFT JOIN LOAN_IN_DUBILL_INFO C --表内借据信息
        ON C.CONT_ID = A.CONT_ID
       AND C.CONT_ID IS NOT NULL
       AND C.RN = 1 --限制同一个合同号多个业务品种数据
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST D --个人客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.CUST_ID IS NOT NULL
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO E --对公客户信息
        ON E.CUST_ID = A.CUST_ID
       AND E.CUST_ID IS NOT NULL
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        --ON CODE.SRC_VALUE_CODE = C.LOAN_BIZ_TYP
        ON CODE.SRC_VALUE_CODE = A.LOAN_PROD_TYP
       AND CODE.SRC_CLASS_CODE = 'T0001' --信贷业务种类
       AND CODE.TAR_CLASS_CODE = 'T0001' --信贷业务种类
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.MAIN_GUA_MODE
       AND CODE1.SRC_CLASS_CODE = 'D0037' --担保类型
       AND CODE1.TAR_CLASS_CODE = 'D0037' --担保类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.CONT_STAT
       AND CODE2.SRC_CLASS_CODE = 'D0117' --合同状态
       AND CODE2.TAR_CLASS_CODE = 'D0117' --合同状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
      LEFT JOIN EMP_INFO F --ADD BY LIP 20251105 --更新信贷合同表客户经理工号是中文的数据
        ON F.EMP_NM = TRIM(A.CUST_MGR_NO) --NOT REGEXP_LIKE(TRIM(A.CUST_MGR_NO),'[0-9]')
       AND F.RN = 1
     WHERE ((TRIM(A.MON_FLG) = 'Y' AND A.CONT_STAT NOT IN ('01','06') --MOD BY LIP 20230609 剔除未生效和撤销数据
             AND NVL(A.CONT_START_DT,'99991231') NOT IN ('99991231','00010101')) --根据一表通口径调整，过滤合同起始日为空数据 MOD BY LIP 20251107
            OR C.CONT_ID IS NOT NULL)
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --判断数据是否重复
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '判断数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,XDHTH,COUNT(1)
      FROM RRP_EAST.EAST5_501_XDHTB T
     WHERE CJRQ = V_MONTH_END_DATEID
     GROUP BY CJRQ,XDHTH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_501_XDHTB(CJRQ,XDHTH)数据重复';
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

END ETL_EAST5_501_XDHTB;
/

