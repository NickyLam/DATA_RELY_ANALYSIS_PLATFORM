CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_502_HLWDKHTFJB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
 **  存储过程详细说明：互联网贷款合同附加表
 **  存储过程名称:  ETL_EAST5_502_HLWDKHTFJB
 **  存储过程创建日期:2022-07-11
 **  存储过程创建人:付善斌
 **  来源表:
 **        M_LOAN_NET_COOP_SUB T --互联网贷款合作协议表
 **        M_LOAN_CONT_INFO A --贷款合同信息
 **        M_LOAN_CONT_INFO A --贷款合同信息
 **        M_PUM_ORG_INFO_EAST B --机构表
 **        CODE_MAP CODE --码值配置表
 **        CONFIG_ORG_REL ORG --机构级次关系表
 **        CONFIG_TABLE_LIST  --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
 **
 **  目标表:   EAST5_502_HLWDKHTFJB
 **
 ** 修改日期    修改人   修改内容
 ** 20231018    LIP      因均衡助贷有多个协议，调整为合作协议编号和合作方责任金额取数口径
 ************************************************************************/
IS
  V_DATE             DATE;           --数据日期(判断输入参数日期格式是否准确)
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
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_502_HLWDKHTFJB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_502_HLWDKHTFJB'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_DATE    := TO_DATE(I_P_DATE,'YYYYMMDD');
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(V_DATE),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --增加分区
    V_STEP := 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '装入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_502_HLWDKHTFJB(
      RID,          --主键
      JRXKZH,       --金融许可证号
      NBJGH,        --内部机构号
      YHJGMC,       --银行机构名称
      XDHTH,        --信贷合同号
      YWMS,         --业务模式
      HZXYBH,       --合作协议编号
      BZ,           --币种
      HZFZRJE,      --合作方责任金额
      LXDH,         --申请人联系电话
      SQSBH,        --客户数据授权书编号
      SXRQ,         --授权生效日期
      ZZRQ,         --授权终止日期
      HTZT,         --合同状态
      BBZ,          --备注
      CJRQ,         --采集日期
      DEPT_NO,      --部门编号
      SRC_SYS_ID,   --来源系统ID
      ISSUED_NO,    --填报机构
      ORG_NO,       --报送机构
      ADDRESS,      --归属地
      DKCPMC,       --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款
      LXDH_ORIG,    --申请人联系电话（脱敏前）
      GSFZJG,       --归属分支机构
      KHTYBH        --客户统一编号 --ADD BY LIP
      )
      WITH TMP1 AS (
    SELECT COOP_AGRT_ID,SUB_COOP_AGRT_ID,
           MAX(COOP_MODE) AS COOP_MODE, --ADD BY LIP 20260316
           MAX(PNR_FND_PCT) AS PNR_FND_PCT, --MOD BY LIP 20231018
           MIN(AGRT_START_DT) AGRT_START_DT,
           MAX(ISMAINAGREEMENT) ISMAINAGREEMENT --ADD BY LIP 20251202
      FROM RRP_MDL.M_LOAN_NET_COOP_SUB --互联网贷款合作协议表
     WHERE DATA_DT = V_P_DATE
     GROUP BY COOP_AGRT_ID,SUB_COOP_AGRT_ID),
      TMP2 AS (--MODIFY BY TANGAN AT 20221228 零售部分业务实际终止时间落在报送期内的数据
    SELECT CONT_ID,
           SUM(LOAN_AMT) AS LOAN_AMT, --放款金额 --ADD BY LIP 20260316
           SUM(LOAN_AMT/FND_PCT*(100-FND_PCT)) AS PNR_RESP_AMT --合作方责任金额 --ADD BY LIP 20260316
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO --表内借据信息
     WHERE EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND NET_LOAN_FLG = 'Y'
       AND DATA_DT = V_P_DATE
     GROUP BY CONT_ID),
    --MOD BY LIP 20250731 合同表的合作协议编号会有多个，用;分割，需先拆分
    LOAN_CONT_INFO AS (
    SELECT C.COOP_AGRT_ID FROM RRP_MDL.M_LOAN_CONT_INFO C --贷款合同信息
     WHERE C.DATA_DT = V_P_DATE
     GROUP BY C.COOP_AGRT_ID),
    LOAN_CONT_INFO_TMP AS (
    SELECT C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL) COOP_AGRT_ID_ST
      FROM LOAN_CONT_INFO C
   CONNECT BY LEVEL <= LENGTH(C.COOP_AGRT_ID) - LENGTH(REPLACE(C.COOP_AGRT_ID, ';')) + 1
     GROUP BY C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL))
    SELECT SYS_GUID()                                             AS RID,          --主键
           B.FIN_PERMIT_NO                                        AS JRXKZH,       --金融许可证号
           B.ORG_ID                                               AS NBJGH,        --内部机构号
           B.ORG_NM                                               AS YHJGMC,       --银行机构名称
           A.CONT_ID                                              AS XDHTH,        --信贷合同号
           CASE WHEN A.COOP_AGRT_ID IS NOT NULL THEN '合作'
                ELSE '独立'
            END                                                   AS YWMS,         --业务模式
           --A.COOP_AGRT_ID                                         AS HZXYBH,         --合作协议编号
           --MOD BY LIP 20231018
           --D.SUB_COOP_AGRT_ID                                     AS HZXYBH,         --合作协议编号
           NVL(D.SUB_COOP_AGRT_ID,'无')                           AS HZXYBH,       --合作协议编号 --MOD BY LIP 20241220
           A.CUR                                                  AS BZ,           --币种
           --NVL(A.PNR_RESP_AMT,0)                                  AS HZFZRJE,      --合作方责任金额
           --MOD BY LIP 20231018
           --NVL(A.PNR_RESP_AMT,0)*NVL(D.PNR_FND_PCT,1)             AS HZFZRJE,      --合作方责任金额
           /*--MOD BY LIP 20260316 按照张家伟提供的口径调整
           1、按照合作协议的“合作方式”进行判断，如合作方式为“联合贷款”，则都按照我行放款金额除以我行出资比例乘以合作方出资比例。
           2、如合作方式为“担保增信”，则按照我行放款金额。--放款金额是指我们行的放款金额
           3、如为其他合作方式则责任金额为0.*/
           CASE WHEN D.COOP_MODE LIKE '%02%' --02 联合贷款
                THEN NVL(E.PNR_RESP_AMT,0)
                WHEN D.COOP_MODE LIKE '%05%' --05 担保增信
                THEN NVL(E.LOAN_AMT,0)
                ELSE 0
            END                                                   AS HZFZRJE,      --合作方责任金额
           CASE WHEN T.CUST_ID IS NOT NULL THEN T.PHONE_NUM_DESEN
                WHEN T1.CUST_ID IS NOT NULL THEN T1.TEL --ADD BY LIP 20250228 微业贷新增对公客户的相关数据
                ELSE RRP_EAST.SM3_ENCRYPT(A.APP_PSN_TEL)
            END                                                   AS LXDH,         --申请人联系电话 --MODIFY BY LIP 20230803
           --A.CUST_DATA_AUTH_ID                                    AS SQSBH,        --客户数据授权书编号
           CASE WHEN TRIM(A.CUST_DATA_AUTH_ID) NOT IN ('合作方未提供') THEN A.CUST_DATA_AUTH_ID --MOD BY LIP 20250408
                WHEN A.COOP_AGRT_ID IS NOT NULL THEN A.CUST_DATA_AUTH_ID
                --ELSE '未签订'
                ELSE '已签订未进行编号' --MOD BY LIP 20250210
            END                                                   AS SQSBH,        --客户数据授权书编号 --MOD BY LIP 20241220
           NVL(A.GRANT_EFF_DT,'99991231')                         AS SXRQ,         --授权生效日期
           NVL(A.GRANT_END_DT,'99991231')                         AS ZZRQ,         --授权终止日期
           CASE WHEN A.CONT_STAT = '01' THEN '未生效'
                WHEN A.CONT_STAT = '02' THEN '有效'
                WHEN A.CONT_STAT = '06' THEN '撤销'
                WHEN A.CONT_STAT = '07' THEN '终结'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME,'其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                   AS HTZT,         --合同状态
           ''                                                     AS BBZ,          --备注
           V_P_DATE                                               AS CJRQ,         --采集日期
           '000'                                                  AS DEPT_NO,      --部门编号
           '01'                                                   AS SRC_SYS_ID,   --来源系统ID
           '000000'                                               AS ISSUED_NO,    --填报机构
           ORG.ORG_ID_LEL_0                                       AS ORG_NO,       --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                   AS ADDRESS,      --归属地
           /*CASE WHEN UPPER(A.DATA_SRC) IN ('ICMS','ICBS','对公信贷') THEN '对公贷款'
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
            END                                                   AS DKCPMC,       --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款*/
           A.LOAN_PROD_NM                                         AS DKCPMC,       --贷款产品名称 --MOD BY LIP 20251216 直接展示所有产品名称
           --A.APP_PSN_TEL                                          AS LXDH_ORIG,  --申请人联系电话（脱敏前）--MODIFY BY LIP 20220510
           CASE WHEN T.CUST_ID IS NOT NULL THEN T.PHONE_NUM
                WHEN T1.CUST_ID IS NOT NULL THEN T1.TEL --ADD BY LIP 20250228 微业贷新增对公客户的相关数据
                ELSE A.APP_PSN_TEL
            END                                                   AS LXDH_ORIG,    --申请人联系电话（脱敏前） --MODIFY BY LIP 20230803
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                   AS GSFZJG,       --归属分支机构
           A.CUST_ID                                              AS KHTYBH        --客户统一编号 --ADD BY LIP
      FROM RRP_MDL.M_LOAN_CONT_INFO A --贷款合同信息
      LEFT JOIN LOAN_CONT_INFO_TMP T2 --ADD BY LIP 20250731
        ON T2.COOP_AGRT_ID = A.COOP_AGRT_ID
      LEFT/*INNER*/ JOIN TMP1 D --MOD BY LIP 20241220 因部分产品是独立的，改为LEFT JOIN,在WHERE条件中判断
        --ON D.COOP_AGRT_ID = A.COOP_AGRT_ID
        ON D.COOP_AGRT_ID = T2.COOP_AGRT_ID_ST --MOD BY LIP 20250731
       AND D.AGRT_START_DT <= CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND D.ISMAINAGREEMENT = '0' --非主协议部分
                                   THEN A.CONT_START_DT
                                   ELSE V_P_DATE
                               END --ADD BY LIP 20251113
      LEFT JOIN TMP2 E --MODIFY BY TANGAN AT 20221228
        ON E.CONT_ID = A.CONT_ID
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST T --个人客户信息EAST专用 MOD BY LIP 20230803
        ON T.CUST_ID = A.CUST_ID
       AND T.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T1 --对公客户信息 MOD BY LIP 20250228 微业贷是联合网贷数据
        ON T1.CUST_ID = A.CUST_ID
       AND T1.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.CONT_STAT
       AND CODE.SRC_CLASS_CODE = 'D0117' --合同状态
       AND CODE.TAR_CLASS_CODE = 'D0117' --合同状态
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE ((D.COOP_AGRT_ID IS NOT NULL AND TRIM(A.MON_FLG) = 'Y' AND A.CONT_STAT NOT IN ('01','06') --MOD BY LIP 20241220
            AND NVL(A.CONT_START_DT,'99991231') NOT IN ('99991231','00010101')) --根据一表通口径调整，过滤合同起始日为空数据 MOD BY LIP 20251107
           OR TRIM(E.CONT_ID) IS NOT NULL) --MODIFY BY TANGAN AT 20221228
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20220603 去掉表的主键，通过语句判断数据是否重复
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,XDHTH,HZXYBH,COUNT(1)
      FROM RRP_EAST.EAST5_502_HLWDKHTFJB T
     WHERE CJRQ = V_MONTH_END_DATEID
     GROUP BY CJRQ,XDHTH,HZXYBH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_502_HLWDKHTFJB(CJRQ,XDHTH,HZXYBH)数据重复';
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
    V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
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
  V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
 WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_502_HLWDKHTFJB;
/

