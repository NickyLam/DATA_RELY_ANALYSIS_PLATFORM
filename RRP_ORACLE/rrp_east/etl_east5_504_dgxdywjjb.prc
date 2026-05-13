CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_504_DGXDYWJJB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：对公信贷业务借据表
  **  存储过程名称:  ETL_EAST5_504_DGXDYWJJB
  **  存储过程创建日期:2022-07-14
  **  存储过程创建人:付善斌
  **       M_LOAN_IN_DUBILL_INFO A --表内借据信息
  **       M_GL_INFO C --总账会计科目信息表
  **       M_LOAN_RP_PLAN_INFO E --贷款还款计划信息
  **       M_CRDT_LMT_INFO F --授信额度主表
  **       M_PUM_ORG_INFO_EAST B --机构表
  **       CODE_MAP CODE --码值配置表
  **       CONFIG_ORG_REL ORG --机构级次关系表
  **       CONFIG_TABLE_LIST  --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
  **
  **  目标表:   EAST5_504_DGXDYWJJB
  **  修改日期          修改人      修改项目
  **  20221108          LIP         模型不过滤数据，改成应用层过滤月初前结清的数据
  **  20221122          LHQ         应取账户的实际销户日期
  **  20221209          LHQ        根据业务口径取放款方式为受托支付的交易从支付清单里面取,当多笔受托交易时，取交易流水号
                                   的第一笔,交易状态成功受托支付对象账号,受托支付对象户名,受托支付对象行名
  **  20221228          LHQ        支付清单PAY_STATUS_CD该状态不准，因此删除该条件
  **  20230106          LIP        根据严希婧和张唯口径，只要客户的科技型企业标志为是就判断为是科技贷款
  **  20230106          LIP        贴现部分逾期的（到期日期小于采集日期的数据），修改欠本日期、欠款期数、欠本金额
  **  20230829          LIP        受托支付的，只要受托支付表中有记录，就是受托支付
  **  20260304          LIP        增加贷款入账户名脱敏前和贷款入账户名是否个人字段，并对贷款入账户名进行脱敏
  **  20260324          LIP        按照业务口径调整贷款发放类型
  **  20260330          LIP        按照业务口径增加企业分类和是否存在支付信息字段，调整是否科技贷款取数逻辑
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
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_504_DGXDYWJJB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_504_DGXDYWJJB'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    V_STEP := 1;
    V_STEP_DESC := '程序开始';
    V_STARTTIME := SYSDATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);

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
    INSERT INTO RRP_EAST.EAST5_504_DGXDYWJJB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       DKFHZH, --贷款分户账号
       XDYWZL, --信贷业务种类
       DKFFLX, --贷款发放类型
       FKFS, --放款方式
       BZ, --币种
       DKJE, --贷款金额
       DKYE, --贷款余额
       DKWJFL, --贷款五级分类
       ZQS, --总期数
       DQQS, --当前期数
       ZQCS, --展期次数
       DKFFRQ, --贷款发放日期
       DKDQRQ, --贷款到期日期
       ZJRQ, --终结日期
       QBJE, --欠本金额
       QBRQ, --欠本日期
       BNQXYE, --表内欠息余额
       BWQXYE, --表外欠息余额
       QXRQ, --欠息日期
       LXQKQS, --连续欠款期数
       LJQKQS, --累计欠款期数
       SBXDJJH, --上笔信贷借据号
       DKRZZH, --贷款入账账号
       DKRZHM, --贷款入账户名
       RZZHSSHMC, --入账账号所属行名称
       LLLX, --利率类型
       SJLL, --实际利率
       HKFS, --还款方式
       HKZH, --还款账号
       HKZHSSHMC, --还款账号所属行名称
       JXFS, --计息方式
       XQHKRQ, --下期还款日期
       XQYHBJ, --下期应还本金
       XQYHLX, --下期应还利息
       JJDKYT, --借据贷款用途
       DKTXDQ, --贷款投向地区
       DKTXHY, --贷款投向行业
       SFHLWDK, --是否互联网贷款
       SFLSDK, --是否绿色贷款
       SFSNDK, --是否涉农贷款
       SFPHXSNDK, --是否普惠型涉农贷款
       SFPHXXWQYDK, --是否普惠型小微企业贷款
       SFKJDK, --是否科技贷款
       XDYGH, --信贷员工号
       DKZT, --贷款状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       KHMC_OTH, --客户是否个人客户
       GSFZJG, --归属分支机构
       DKRZHM_ORIG, --贷款入账户名（脱敏前） --ADD BY LIP 20260304
       DKRZHM_OTH, --贷款入账户名是否个人 --ADD BY LIP 20260304
       QYFL, --企业分类 --ADD BY LIP 20260330
       SFCZZFXX --是否存在支付信息 --ADD BY LIP 20260330
       )
      WITH LOAN_ENTRS_PAY_SUB AS (
     /*20221209 LHQ 根据业务口径取放款方式为受托支付的交易从支付清单里面取,当多笔受托交易时，取交易流水号的第一笔,
     交易状态成功受托支付对象账号,受托支付对象户名,受托支付对象行名*/
    SELECT RCPT_ID,      --借据编号
           ENTRS_PAY_AMT,
           ENTRS_PAY_DT,        --受托支付日期
           ENTRS_PAY_OBJ_ACC,   --受托支付对象账号
           ENTRS_PAY_OBJ_ACC_NM,  --受托支付对象户名
           ENTRS_PAY_OBJ_PBC_NO,  --受托支付对象行号
           ENTRS_PAY_OBJ_BANK_NM,  --受托支付对象行名
           ROW_NUMBER() OVER(PARTITION BY RCPT_ID ORDER BY ENTRS_PAY_DT ASC,PAY_FLOW_NUM ASC) AS RN
      FROM RRP_MDL.M_LOAN_ENTRS_PAY_SUB --受托支付子表
     WHERE REPORT_FLAG = 'Y'
       AND DATA_DT = V_P_DATE),
      LOAN_RP_PLAN_INFO AS (
    SELECT RCPT_ID,REPY_PRD_NUM,LEAST(PRIN_EXP_DT,INT_EXP_DT) EXP_DT,INT,PRIN
      FROM RRP_MDL.M_LOAN_RP_PLAN_INFO
     WHERE DATA_DT = V_P_DATE
     GROUP BY RCPT_ID,REPY_PRD_NUM,LEAST(PRIN_EXP_DT,INT_EXP_DT),INT,PRIN),
     IS_SFCZZFXX AS (--ADD BY LIP 20260330 判断借据是否存在支付信息
    SELECT RCPT_ID FROM RRP_MDL.M_LOAN_ENTRS_PAY_SUB --受托支付子表
     WHERE DATA_DT = V_P_DATE GROUP BY RCPT_ID)
    SELECT /*+USE_HASH(A,D,C,E,F,B,CODE1,CODE2,CODE3,CODE4,CODE5,CODE6,CODE7,CODE8,CODE9,CODE11,ORG)*/
           SYS_GUID()                                    AS RID, --数据主键
           B.FIN_PERMIT_NO                               AS JRXKZH, --金融许可证号
           B.ORG_ID                                      AS NBJGH, --内部机构号
           B.ORG_NM                                      AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                         AS MXKMBH, --明细科目编号
           C.SUBJ_NM                                     AS MXKMMC, --明细科目名称
           A.CUST_ID                                     AS KHTYBH, --客户统一编号
           --D.CUST_NM                                     AS KHMC, --客户名称
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                          AS KHMC, --客户名称
           A.CONT_ID                                     AS XDHTH, --信贷合同号
           A.RCPT_ID                                     AS XDJJH, --信贷借据号
           --A.RCPT_ID                                   AS DKFHZH, --贷款分户账号
           A.ACC_ID                                      AS DKFHZH, --贷款分户账号
           CASE WHEN A.LOAN_BIZ_TYP = '020101' THEN '流动资金贷款'
                WHEN A.LOAN_BIZ_TYP = '0602' THEN '法人账户透支'
                WHEN A.PROJ_LOAN_FLG = 'Y' OR A.LOAN_STD_PROD_ID = '203010300001' THEN '项目贷款' --20230525 MOD BY LIP 增加并购贷款
                WHEN A.SYN_LOAN_FLG = 'Y' THEN '项目贷款（银团）'
                /*MODIFY BY LIP 20220718因深圳银监对数要求，增加经营性物业贷款的区分标志 按S67口径
                将对公的一般固定资产贷款中的 203010200001 经营性物业贷款 标记为 其他-经营性物业贷款
                将个人的个人经营性贷款中的 201020100048 个人经营性物业抵押贷款 标记为 其他-经营性物业贷款*/
                WHEN A.LOAN_STD_PROD_ID IN ('203010200001','201020100048') THEN '其他-经营性物业贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0202' THEN '一般固定资产贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0101%' THEN '住房按揭贷款'
                WHEN A.LOAN_BIZ_TYP IN ('010201', '010203') THEN '商用房贷款'
                WHEN A.LOAN_BIZ_TYP IN ('010202', '010301') THEN '汽车贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0104%' THEN '助学贷款'
                WHEN A.LOAN_BIZ_TYP = '010399' THEN '消费贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0103%' THEN '消费贷款'
                WHEN A.LOAN_BIZ_TYP = '010299' THEN '个人经营性贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0301%' THEN '票据贴现'
                WHEN A.LOAN_BIZ_TYP LIKE '030201%' THEN '买断式转贴现'
                WHEN A.LOAN_BIZ_TYP LIKE '0204%' OR A.LOAN_STD_PROD_ID IN ('203030600002','203020300002') THEN '贸易融资业务'
                --WHEN A.LOAN_BIZ_TYP LIKE '0204%' OR A.LOAN_BIZ_TYP IN ('0399') THEN '贸易融资业务'
                WHEN A.LOAN_BIZ_TYP = '0206' THEN '融资租赁业务'
                WHEN A.LOAN_BIZ_TYP LIKE '0205%' THEN '垫款'
                WHEN A.LOAN_BIZ_TYP = '90' THEN '委托贷款'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE9.TAR_VALUE_NAME,'其他-',''),1,100))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE9.TAR_VALUE_NAME,'其他-',''),1,150))
            END                                          AS XDYWZL, --信贷业务种类
           /*CASE WHEN A.LOAN_FRM = '04' THEN '重组贷款'
                WHEN A.RCMM_LOAN_FLG = 'Y' AND A.LOAN_FRM IN ('05','9906') THEN '重组贷款' --ADD BY LIP 20260311 根据一表通的逻辑调整
                WHEN A.LOAN_FRM = '05' THEN '无还本续贷'
                WHEN A.LOAN_FRM = '03' THEN '借新还旧'
                WHEN NVL(A.EXTN_CNT,0) > 0 AND A.LOAN_STD_PROD_ID <> '202010100004' THEN '其他-展期' --展期 --ADD BY LIP 20260316 参考一表通
                WHEN A.LOAN_FRM = '02' THEN '其他-贷款转入'
                WHEN A.LOAN_FRM = '01' THEN '新增'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE10.TAR_VALUE_NAME,'其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE10.TAR_VALUE_NAME,'其他-',''),1,30))
            END                                          AS DKFFLX, --贷款发放类型*/
           /*--MOD BY LIP 20260324 根据严希婧提出需求调整
           3、对公信贷业务借据表放款方式，规范取值：
          （1）业务类型为法人账户透支，放款方式统一为“其他-法人账户投资”，备注“该笔为法人账户透支业务，根据《银行业金融机构监管数据标准化规范（2021版）填报口径（第一期）》第1306号答疑，该种业务场景应按 “其他-法人账户透支”填报”
          （2）贷款发放类型为“重组”（取值口径参考一表通，注意三种情况，一种是根据借据发生类型“重组”直接取，另一种是通过信贷系统提供借据与重组批复的关联关系识别“重组”，三是系统直接默认为重组，借据号包括20221215023001、20221216122340001、20221208122325001、20221211001001、20221216122341001）
          （3）贷款发放类型为“无还本续贷”（取值口径参考一表通，取信贷系统业务贷款发放类型为“无还本续贷”或者存量已打标签借据），放款方式统一为“其他-无还本续贷”
          （4）贷款发放类型为“借新还旧”（取信贷系统业务贷款发放类型为“借新还旧”，剔除已打标“无还本续贷”的借据），放款方式统一为“借新还旧”
          （5）贷款发放类型为“展期”（取值口径参考一表通）
          （6）票据贴现、转贴现、贸易融资、融资租赁、垫款均填报至“其他”项中
          （7）针对“重组”、“无还本续贷”、“借新还旧”、“展期”，总的处理原则是优先判断重组，其次判断无还本续贷、借新还旧，然后再判断展期，剩下的归类到新增。*/
           CASE WHEN A.LOAN_BIZ_TYP = '0602' THEN '其他-法人账户投资'
                WHEN A.LOAN_FRM = '04' THEN '重组贷款'
                WHEN A.RCMM_LOAN_FLG = 'Y' AND A.LOAN_FRM IN ('05','9906') THEN '重组贷款' --ADD BY LIP 20260311 根据一表通的逻辑调整
                WHEN A.LOAN_FRM = '05' THEN '无还本续贷'
                WHEN A.LOAN_FRM = '03' THEN '借新还旧'
                WHEN NVL(A.EXTN_CNT,0) > 0 AND A.LOAN_STD_PROD_ID <> '202010100004' THEN '其他-展期' --展期 --ADD BY LIP 20260316 参考一表通
                WHEN SUBSTR(A.LOAN_STD_PROD_ID,1,7) IN ('2040102') THEN '其他-票据贴现' --MOD BY LIP 20260325 直贴
                WHEN SUBSTR(A.LOAN_STD_PROD_ID,1,7) IN ('2040101') THEN '其他-票据转贴现' --MOD BY LIP 20260325 转贴现
                WHEN SUBSTR(A.LOAN_STD_PROD_ID,1,5) IN ('20302','20303') THEN '其他-贸易融资' --MOD BY LIP 20260325 国际贸易融资 国内贸易融资
                WHEN SUBSTR(A.LOAN_STD_PROD_ID,1,5) IN ('20304') THEN '其他-垫款' --MOD BY LIP 20260325 垫款
                ELSE '新增'
            END                                          AS DKFFLX, --贷款发放类型
           /*--MOD BY LIP 20231219 根据严希婧口径调整：
           票据贴现、转贴现、垫款、贸易融资（口径同1104、含代付、保理、押汇、福费廷等） 不适用 受托支付/自主支付判断，
           参考答疑口径，放款方式填“其他-票据放款”、“其他-垫款”、“其他-贸易融资”*/
           CASE WHEN A.LOAN_BIZ_TYP = '0602' THEN '其他-法人账户投资' --MOD BY LIP 20260416
                WHEN A.LOAN_FRM = '05' THEN '其他-无还本续贷' --MOD BY LIP 20260416
                WHEN A.LOAN_FRM = '03' THEN '其他-借新还旧' --MOD BY LIP 20260416
                WHEN A.LOAN_BIZ_TYP LIKE '0301%' THEN '其他-票据放款' --票据贴现
                WHEN A.LOAN_BIZ_TYP LIKE '030201%' THEN '其他-票据放款' --买断式转贴现
                WHEN A.LOAN_BIZ_TYP LIKE '0205%' THEN '其他-垫款' --垫款
                WHEN A.LOAN_BIZ_TYP LIKE '0204%' OR A.LOAN_STD_PROD_ID IN ('203030600002','203020300002') THEN '其他-贸易融资' --贸易融资业务
                WHEN SUB.RCPT_ID IS NOT NULL THEN '受托支付' --对公借据，当受托支付表中有数时，就是受托支付
                --ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,20))
                ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,30))
            END                                          AS FKFS, --放款方式
           A.CUR                                         AS BZ, --币种
           --A.LOAN_AMT                                    AS DKJE, --贷款金额
           CASE WHEN A.LOAN_PROD_ID IN ('203020300001','203030600001','203030600002','204010100002','204010100001')
                THEN NVL(A.BILL_ACT_AMT,0) --转贴现（后两个）、福费廷(前3个)的贷款金额取实付金额
                ELSE NVL(A.LOAN_AMT,0)
            END                                          AS DKJE, --贷款金额 --MODIFY BY LIP 20220502 根据业务需求修改*/
           --A.LOAN_BAL                                    AS DKYE, --贷款余额
           CASE WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID NOT LIKE '1301%' THEN NVL(A.LOAN_BAL,0)
                WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID LIKE '1301%' THEN NVL(A.LOAN_BAL,0) - NVL(A.INT_ADJ,0)
                ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
            END                                          AS DKYE, --贷款余额 MODIFY BY LIP 20220427
           CODE2.TAR_VALUE_NAME                          AS DKWJFL, --贷款五级分类
           CASE WHEN A.TOT_PRD_NUM = 0 THEN 1
                ELSE A.TOT_PRD_NUM END                   AS ZQS, --总期数   20221226 LHQ 根据银监答疑口径填报为1
           CASE WHEN A.CURR_PRD = 0 THEN 1
                ELSE A.CURR_PRD END                      AS DQQS, --当前期数  20230106 LHQ 根据银监答疑口径填报为1
           NVL(A.EXTN_CNT,0)                             AS ZQCS, --展期次数
           NVL(A.LOAN_ACT_DSTR_DT,'99991231')            AS DKFFRQ, --贷款发放日期
           --NVL(A.LOAN_ACT_EXP_DT,'99991231')             AS DKDQRQ, --贷款到期日期
           CASE WHEN A.LOAN_BIZ_TYP LIKE '030201%' THEN NVL(A.LOAN_ORIG_EXP_DT,'99991231')
                ELSE NVL(A.LOAN_ACT_EXP_DT,'99991231')
            END                                          AS DKDQRQ, --贷款到期日期
           /*CASE WHEN NVL(A.CNL_ACC_DT,'29991231') IN ('00010101','20991231','29991231') THEN '99991231'
                ELSE A.CNL_ACC_DT
            END                                          AS ZJRQ, --终结日期*/
           CASE WHEN NVL(A.ACT_END_DT,'29991231') IN ('00010101','20991231','29991231') THEN '99991231'
                WHEN A.ACT_END_DT > V_P_DATE THEN '99991231' --ADD BY LIP 20260213
                ELSE A.ACT_END_DT
            END                                          AS ZJRQ, --终结日期 --MOD BY LIP 20250612 贷款结清、核销或转让的日期
           --NVL(A.OVD_PRIN_BAL,0)                         AS QBJE, --欠本金额
           CASE WHEN A.LOAN_BIZ_TYP LIKE '0301%' AND NVL(A.LOAN_ACT_EXP_DT,'99991231') < V_P_DATE
                     AND NVL(A.CNL_ACC_DT,'99991231') IN ('00010101','20991231','29991231','99991231')
                THEN A.DISTR_AMT --MOD BY LIP 20230629 贴现逾期的欠本金额为票面金额
                WHEN NVL(A.CNCL_DT,'99991231') <= V_P_DATE THEN 0
                ELSE NVL(A.OVD_PRIN_BAL,0)
            END                                          AS QBJE, --欠本金额
           --NVL(A.PRIN_OVD_DT,'99991231')                 AS QBRQ, --欠本日期
           CASE WHEN A.LOAN_BIZ_TYP LIKE '0301%' AND NVL(A.LOAN_ACT_EXP_DT,'99991231') < V_P_DATE
                     AND NVL(A.CNL_ACC_DT,'99991231') IN ('00010101','20991231','29991231','99991231')
                THEN A.LOAN_ACT_EXP_DT --MOD BY LIP 20230629 贴现逾期
                ELSE NVL(A.PRIN_OVD_DT,'99991231')
            END                                          AS QBRQ, --欠本日期
           /*NVL(A.IN_INT_OVD_BAL,0)                       AS BNQXYE, --表内欠息余额
           NVL(A.OUT_INT_OVD_BAL,0)                      AS BWQXYE, --表外欠息余额*/
           CASE WHEN NVL(A.CNCL_DT,'99991231') <= V_P_DATE THEN 0
                ELSE NVL(A.IN_INT_OVD_BAL,0)
            END                                          AS BNQXYE, --表内欠息余额
           CASE WHEN NVL(A.CNCL_DT,'99991231') <= V_P_DATE THEN 0
                ELSE NVL(A.OUT_INT_OVD_BAL,0)
            END                                          AS BWQXYE, --表外欠息余额
           NVL(A.INT_OVD_DT,'99991231')                  AS QXRQ, --欠息日期
           /*NVL(A.CNU_DEBT_PRD_NUM,0)                     AS LXQKQS, --连续欠款期数
           NVL(A.CUM_DEBT_PRD_NUM,0)                     AS LJQKQS, --累计欠款期数*/
           --当没有还款计划，期数为0，欠本金额+表内欠息+表外欠息大于0时，连续欠款期数默认为 1
           CASE WHEN A.TOT_PRD_NUM = 0 AND NVL(A.CNCL_DT,'99991231') > V_P_DATE
                     AND NVL(A.OVD_PRIN_BAL,0)+ NVL(A.IN_INT_OVD_BAL,0) + NVL(A.OUT_INT_OVD_BAL,0) > 0
                THEN 1
                WHEN A.LOAN_BIZ_TYP LIKE '0301%' AND NVL(A.LOAN_ACT_EXP_DT,'99991231') < V_P_DATE
                     AND NVL(A.CNL_ACC_DT,'99991231') IN ('00010101','20991231','29991231','99991231')
                THEN 1  --MOD BY LIP 20230629 贴现逾期
                ELSE NVL(A.CNU_DEBT_PRD_NUM,0)
            END                                          AS LXQKQS, --连续欠款期数
           --当没有还款计划，期数为0，欠本金额+表内欠息+表外欠息大于0时，累计欠款期数默认为 1
           CASE WHEN A.TOT_PRD_NUM = 0 AND NVL(A.CNCL_DT,'99991231') > V_P_DATE
                     AND NVL(A.OVD_PRIN_BAL,0)+ NVL(A.IN_INT_OVD_BAL,0) + NVL(A.OUT_INT_OVD_BAL,0) > 0
                THEN 1
                WHEN A.LOAN_BIZ_TYP LIKE '0301%' AND NVL(A.LOAN_ACT_EXP_DT,'99991231') < V_P_DATE
                     AND NVL(A.CNL_ACC_DT,'99991231') IN ('00010101','20991231','29991231','99991231')
                THEN 1 --MOD BY LIP 20230629 贴现逾期
                ELSE NVL(A.CUM_DEBT_PRD_NUM,0)
            END                                          AS LJQKQS, --累计欠款期数
           --TRIM(A.ORIG_RCPT_NO)                          AS SBXDJJH, --上笔信贷借据号
           SUBSTRB(TRIM(A.ORIG_RCPT_NO),1,100)           AS SBXDJJH, --上笔信贷借据号 --MOD BY LIP 20240807
           /*A.ETR_ACC                                     AS DKRZZH, --贷款入账账号
           A.ETR_ACC_NM                                  AS DKRZHM, --贷款入账户名
           A.LOAN_ETR_ACC_OPEN_BANK_NM                   AS RZZHSSHMC, --入账账号所属行名称*/
           /*20221209 LHQ 根据业务口径取放款方式为受托支付的交易从支付清单里面取,当多笔受托交易时，取交易流水号的第一笔,
            交易状态成功受托支付对象账号,受托支付对象户名,受托支付对象行名*/
           CASE WHEN /*A.DSBR_MODE = '02' AND*/ TRIM(SUB.ENTRS_PAY_OBJ_ACC) IS NOT NULL THEN SUB.ENTRS_PAY_OBJ_ACC
                ELSE A.ETR_ACC
            END                                          AS DKRZZH,   --贷款入账账号
           /*CASE WHEN A.DSBR_MODE = '02' THEN SUB.ENTRS_PAY_OBJ_ACC_NM
                ELSE A.ETR_ACC_NM
            END                                          AS DKRZHM, --贷款入账户名*/
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND LENGTH(TRIM(REGEXP_REPLACE(SUB.ENTRS_PAY_OBJ_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(SUB.ENTRS_PAY_OBJ_ACC_NM,'[[:punct:]]',''),0)) --ADD BY LIP 20260304
                WHEN /*A.DSBR_MODE = '02' AND*/ TRIM(SUB.ENTRS_PAY_OBJ_ACC) IS NOT NULL
                   AND REGEXP_REPLACE(TRIM(SUB.ENTRS_PAY_OBJ_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(SUB.ENTRS_PAY_OBJ_ACC_NM),'(','（'),')','）'),' ','')
                WHEN /*A.DSBR_MODE = '02' AND*/ TRIM(SUB.ENTRS_PAY_OBJ_ACC) IS NOT NULL
                THEN TRIM(SUB.ENTRS_PAY_OBJ_ACC_NM)
                WHEN REGEXP_REPLACE(TRIM(A.ETR_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.ETR_ACC_NM),'(','（'),')','）'),' ','')
                ELSE A.ETR_ACC_NM
            END                                          AS DKRZHM, --贷款入账户名
           CASE WHEN /*A.DSBR_MODE = '02' AND*/ TRIM(SUB.ENTRS_PAY_OBJ_ACC) IS NOT NULL
                THEN TRIM(SUB.ENTRS_PAY_OBJ_BANK_NM)
                ELSE A.LOAN_ETR_ACC_OPEN_BANK_NM
            END                                          AS RZZHSSHMC, --入账账号所属行名称
           CASE WHEN A.PRC_BASE_TYP = 'TR07' THEN 'LPR'
                ELSE '非LPR'
            END                                          AS LLLX, --利率类型
           A.EXEC_RATE                                   AS SJLL, --实际利率
           CASE WHEN A.GXH_PAY_TYPE = '4' THEN '分期付息一次还本' --MODIFY BY TANGAN AT 20221229 4-按频率付息，一次还本
                WHEN A.GXH_PAY_TYPE = '3' AND SUBSTR(A.SUBJ_ID,1,4) = '1313' THEN '分期付息一次还本' --MODIFY BY TANGAN AT 20221229 3-一次性还本付息/前收息 1313-垫款
                WHEN A.GXH_PAY_TYPE = '3' AND SUBSTR(A.SUBJ_ID,1,4) = '1305' AND A.LOAN_STD_PROD_ID IN ('203030600001','203020300001','203030600002','203030500015','203030500014') THEN '其他-到期一次性还本无息' --MODIFY BY TANGAN AT 20221229 3-一次性还本付息/前收息 1305-贸易融资
                WHEN A.GXH_PAY_TYPE = '3' AND SUBSTR(A.SUBJ_ID,1,4) = '3007' AND EXEC_RATE = 0.00 THEN '其他-到期一次性还本无息' --MODIFY BY TANGAN AT 20221229 3-一次性还本付息/前收息 3007-委托贷款
                WHEN A.GXH_PAY_TYPE = '3' THEN '其他-到期一次性还本付息' --MODIFY BY TANGAN AT 20221229 3-一次性还本付息/前收息
                WHEN A.GXH_PAY_TYPE = '10' THEN '其他-按还款计划还款' --MODIFY BY TANGAN AT 20221229 10-组合还款
                WHEN NVL(A.REPY_MODE,'99') IN ('99','9903') AND A.GXH_PAY_TYPE NOT IN ('-')
                     /*AND TRIM(SUBSTRB(CODE31.TAR_VALUE_NAME,1,40)) IS NOT NULL
                THEN TRIM(SUBSTRB(CODE31.TAR_VALUE_NAME,1,40))
                ELSE TRIM(SUBSTRB(CODE3.TAR_VALUE_NAME,1,40))*/
                     AND TRIM(SUBSTRB(CODE31.TAR_VALUE_NAME,1,60)) IS NOT NULL
                THEN TRIM(SUBSTRB(CODE31.TAR_VALUE_NAME,1,60))
                ELSE TRIM(SUBSTRB(CODE3.TAR_VALUE_NAME,1,60))
            END                                          AS HKFS, --还款方式
           A.REPY_ACC                                    AS HKZH, --还款账号
           A.LOAN_REPY_ACC_OPEN_BANK_NM                  AS HKZHSSHMC, --还款账号所属行名称
           --CODE4.TAR_VALUE_NAME                         AS JXFS, --计息方式
           CASE --020402+ 020401 贸易融资(福费廷，保理) 03020101+ 03020102+030101+030102 票据贴现、转贴现改为 “其他-不适用 修改日期：20221130
                WHEN A.LOAN_BIZ_TYP IN (/*'020402',*/'020401','03020101','03020102','030101','030102')
                 AND LOAN_PROD_ID IN ('203020300001','203020300002','203030600001','203030600002','203040600001','203030500002',
                                      '203030500003','203030500004','203030500005','203030500006','203030500007','203030500008',
                                      '203030500009','203030500010','203030500011','203030500012','203030500013',
                                      /*'203030500014','203030500015',*/
                                      '204010200001','204010200002','204010100002','204010100001') THEN '其他-不适用'
                                      --20221226 LHQ 票据贴现、转贴现'204010200001','204010200002','204010100002','204010100001'改为 其他-不适用
                                      --20221226 LHQ 取消保理业务的赋值处理,保理的计息方式存在多种情形：放款时计息、参照流动资金贷款计息方式、到期日计息；因此应按系统实际结息方式报送
                WHEN A.GXH_PAY_TYPE = '3' THEN '其他-到期日结息'
                --ELSE TRIM(SUBSTRB(CODE4.TAR_VALUE_NAME,1,40))
                ELSE TRIM(SUBSTRB(CODE4.TAR_VALUE_NAME,1,60))
            END                                        AS JXFS, --计息方式
           --NVL(E.PRIN_EXP_DT,'99991231')               AS XQHKRQ, --下期还款日期
           CASE WHEN A.ACT_END_DT <= V_P_DATE THEN '99991231'
                --若本期为最后一期，还款日期填写默认值
                WHEN A.CURR_PRD = A.TOT_PRD_NUM AND NVL(E.EXP_DT,'99991231') < V_P_DATE THEN '99991231'
                ELSE NVL(E.EXP_DT,'99991231')
            END                                          AS XQHKRQ, --下期还款日期
           CASE WHEN A.ACT_END_DT <= V_P_DATE THEN 0
                --若本期为最后一期，还款金额可填写0
                WHEN A.CURR_PRD = A.TOT_PRD_NUM AND NVL(E.EXP_DT,'99991231') < V_P_DATE THEN 0
                ELSE NVL(E.PRIN,0)
            END                                          AS XQYHBJ, --下期应还本金
           CASE WHEN A.ACT_END_DT <= V_P_DATE THEN 0
                --若本期为最后一期，还款金额可填写0
                WHEN A.CURR_PRD = A.TOT_PRD_NUM AND NVL(E.EXP_DT,'99991231') < V_P_DATE THEN 0
                ELSE NVL(E.INT,0)
            END                                          AS XQYHLX, --下期应还利息
           TRIM(REPLACE(REPLACE(A.LOAN_USEAGE,CHR(10),''),CHR(13),'')) AS JJDKYT, --借据贷款用途
           CASE WHEN A.LOAN_DIR_RGN <> '000000' THEN A.LOAN_DIR_RGN
                ELSE D.OPR_LAND_AREA_CD
            END                                          AS DKTXDQ, --贷款投向地区
           CASE WHEN A.LOAN_DIR_BIO_FLG = 'N' AND A.DATA_SRC IN ('对公信贷') AND A.LOAN_PROD_ID <> '203020300002' THEN '3.对境外贷款'
                WHEN A.LOAN_BIZ_TYP = '0701' THEN '2.21.1个人贷款-信用卡'
                WHEN A.LOAN_BIZ_TYP = '010301' THEN '2.21.2个人贷款-汽车'
                WHEN A.LOAN_BIZ_TYP = '010101' THEN '2.21.3个人贷款-住房按揭贷款'
                WHEN (A.LOAN_BIZ_TYP LIKE '01%' AND A.LOAN_BIZ_TYP NOT IN ('010301','010101')
                     AND A.LOAN_BIZ_TYP NOT LIKE '0102%') OR A.LOAN_BIZ_TYP = '010201' THEN '2.21.4个人贷款-其他'--商业住房贷款填写在 2.21.4其他
                WHEN A.LOAN_BIZ_TYP LIKE '0302%' THEN '2.22买断式转贴现'
                WHEN A.LOAN_BIZ_TYP = '0399' OR A.LOAN_PROD_ID = '203020300002' THEN '2.23买断其他票据类资产'
                WHEN A.LOAN_DIR_IDY LIKE 'A%' THEN '2.1农、林、牧、渔业'
                WHEN A.LOAN_DIR_IDY LIKE 'B%' THEN '2.2采矿业'
                WHEN A.LOAN_DIR_IDY LIKE 'C%' THEN '2.3制造业'
                --WHEN A.LOAN_DIR_IDY LIKE 'D%' THEN '2.4电力、热力、燃气及水的生产和供应业'
                WHEN A.LOAN_DIR_IDY LIKE 'D%' THEN '2.4电力、热力、燃气及水生产和供应业' --MOD BY LIP 20221123 20240429
                --WHEN A.LOAN_DIR_IDY LIKE 'D%' THEN '2.4电力、热力、燃气及水的生产和供应业' --MOD BY LIP 20230829 根据广东省发布的校验规则修改
                WHEN A.LOAN_DIR_IDY LIKE 'E%' THEN '2.5建筑业'
                WHEN A.LOAN_DIR_IDY LIKE 'F%' THEN '2.6批发和零售业'
                WHEN A.LOAN_DIR_IDY LIKE 'G%' THEN '2.7交通运输、仓储和邮政业'
                WHEN A.LOAN_DIR_IDY LIKE 'H%' THEN '2.8住宿和餐饮业'
                WHEN A.LOAN_DIR_IDY LIKE 'I%' THEN '2.9信息传输、软件和信息技术服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'J%' THEN '2.10金融业'
                WHEN A.LOAN_DIR_IDY LIKE 'K%' THEN '2.11房地产业'
                WHEN A.LOAN_DIR_IDY LIKE 'L%' THEN '2.12租赁和商务服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'M%' THEN '2.13科学研究和技术服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'N%' THEN '2.14水利、环境和公共设施管理业'
                WHEN A.LOAN_DIR_IDY LIKE 'O%' THEN '2.15居民服务、修理和其他服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'P%' THEN '2.16教育'
                WHEN A.LOAN_DIR_IDY LIKE 'Q%' THEN '2.17卫生和社会工作'
                WHEN A.LOAN_DIR_IDY LIKE 'R%' THEN '2.18文化、体育和娱乐业'
                WHEN A.LOAN_DIR_IDY LIKE 'S%' THEN '2.19公共管理、社会保障和社会组织'
                WHEN A.LOAN_DIR_IDY LIKE 'T%' THEN '2.20国际组织'
            END                                          AS DKTXHY, --贷款投向行业
           CODE6.TAR_VALUE_NAME                          AS SFHLWDK, --是否互联网贷款
           NVL(CODE7.TAR_VALUE_NAME,'否')                AS SFLSDK, --是否绿色贷款
           /*CODE8.TAR_VALUE_NAME                          AS SFSNDK, --是否涉农贷款
           CASE WHEN A.AGR_REL_LOAN_FLG = 'Y' AND F.CRDT_TOTAL_LMT <= 10000000 THEN '是'
                ELSE '否'
            END                                          AS SFPHXSNDK, --是否普惠型涉农贷款
           CASE WHEN D.ENT_SCALE IN ('S','X') OR D.CUST_CL = 'E' --个体工商户
                     AND F.CRDT_TOTAL_LMT <= 10000000 THEN '是'
                ELSE '否'
            END                                          AS SFPHXXWQYDK, --是否普惠型小微企业贷款*/
           --MOD BY LIP 20240524 参考1104数据
           CASE WHEN TD.AGCLT_LOAN_MAIN_TYPE_CD IN ('N12','N13') --N12 农村企业贷款 N13 农村各类组织贷款
                THEN '是'
                WHEN (TD.AGCLT_LOAN_MAIN_TYPE_CD IN ('N22','N23') --N22 城市企业涉农贷款 N23 城市各类组织涉农贷款
                      AND (TD.AGR_REL_LOAN_BIZ_TYP = 'A' /*农林牧渔业贷款*/
                           OR TD.AGR_REL_LOAN_BIZ_TYP IN ('B01','B02','B03','B04','B05','B06'))) --支农贷款
                THEN '是'
                ELSE '否'
            END                                        AS SFSNDK, --是否涉农贷款
           CASE WHEN TD.SGL_CRDT_AMT <= 10000000 --单户授信金额 1000万（含）以下
                     AND TD.ENT_SCALE IN ('S', 'X') --企业规模 S小型、X微型
                     AND TD.CORP_CUST_TYP LIKE 'A%' --对公客户类型 企业
                     AND TD.LOAN_DIR_BIO_FLG <> 'N'
                     AND TD.IS_CBRC_ENT = 'Y' --是否企业（银监）
                THEN '是'
                ELSE '否'
            END                                          AS SFPHXSNDK, --是否普惠型涉农贷款
           CASE --WHEN TC.DATA_SRC IN ('对公信贷') AND TC.LOAN_DIR_BIO_FLG <> 'N' --境内外贷款标志 Y境内
                --MOD BY LIP 20260316 根据银监检查语句调整，增加票据部分的判断，与S7101对数
                WHEN ((TC.DATA_SRC IN ('对公信贷') AND TC.LOAN_DIR_BIO_FLG <> 'N') OR TC.DATA_SRC IN ('票据贴现','票据转贴现'))
                     AND TC.CBRC_FLG = 'Y' --CBRC标志 Y-银保监会
                     AND TC.SGL_CRDT_AMT <= 10000000 --单户授信金额 1000万（含）以下
                     AND TC.ENT_SCALE IN ('S','X') --企业规模 S小型、X微型
                     AND TC.IS_CBRC_ENT = 'Y' --是否企业（银监) --ADD BY 于敬艺 20230103
                     --AND TC.CBRC_CUST_CL = '企业' --CBRC客户类型 企业
                THEN '是'
                ELSE '否'
            END                                          AS SFPHXXWQYDK, --是否普惠型小微企业贷款
           /*CASE WHEN D.TECH_ENT_FLG = 'Y' THEN '是' --科技型企业标志
                ELSE '否'
            END                                          AS SFKJDK, --是否科技贷款*/ --MOD BY LIP 20230106 根据严希婧和张唯口径，只要客户的科技型企业标志为是就判断为是科技贷款
           /*--MOD BY LIP 20250228 参考1104的S70取数：“科技型贷款”判断规则调整如下：
           票据转贴现业务，按穿透后直贴申请人匹配客户信息相关标签（【高新技术企业】、【创新型中小企业】、【科技型中小企业】、
           【“专精特新”中小企业】、【“专精特新”小巨人企业】）判断是否科技型贷款*/
           /*CASE WHEN TC.EACH_CLASS_SCEN_TECH_LIST_CORP_FLG = 'Y' THEN '是' --各类科技名单企业标志
                ELSE '否'
            END                                            AS SFKJDK, --是否科技贷款*/
           --MOD BY LIP 20250928 调整是否科技贷款口径，按照S70新表样调整，调整与S70新表样的1.科技贷款_贷款余额取数一致
           CASE WHEN TC.LOAN_DIR_BIO_FLG = 'Y' AND SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0104','0103','0101') --剔除个人消费贷
                     AND TC.DATA_SRC NOT IN ('票据转贴现') --ADD BY LIP 20260330 根据1104口径，剔除买断式转贴现的数据
                THEN CASE WHEN TC.HIGH_TECH_ENT_FLG = 'Y' THEN '是' --各类科技名单企业标志
                          WHEN TC.INOVT_MED_SIDE_ENTER_FLG = 'Y' THEN '是' --创新型中小企业标志
                          WHEN TC.TECH_MID_SML_ENT_FLG = 'Y' THEN '是' --科技型中小企业标志
                          WHEN TC.PRCN_CUST_FLG = 'Y' THEN '是' --专精特新中小企业标志 “专精特新”中小企业（含专精特新“小巨人”企业）
                          WHEN TC.PRCN_LG_CUST_FLG = 'Y' THEN '是' --专精特新小巨人企业标志 “专精特新”中小企业（含专精特新“小巨人”企业）
                          WHEN TC.CTY_CORP_TECH_CENTER_FLG = 'Y' THEN '是' --国家企业技术中心标志 1.1.6其他科技型企业
                          WHEN TC.CTY_TECH_INOVT_CORP_FLG = 'Y' THEN '是' --国家技术创新示范企业标志 1.1.6其他科技型企业
                          WHEN TC.ITEM_CORP_FLG = 'Y' THEN '是' --制造业单项冠军企业标志 1.1.6其他科技型企业 --ADD BY LIP 20260209
                          WHEN TC.EACH_CLASS_SCEN_TECH_LIST_CORP_FLG = 'Y' THEN '是' --各类科技名单企业标志
                          WHEN SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.HIGH_TECH_IDY_MFG_CL IN ('01','02','03','04','05','06') THEN '是' --高技术制造业
                          WHEN SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.HIGH_TECH_IDY_SER_FLG = 'Y' THEN '是' --高技术服务业
                          WHEN TC.LOAN_DIR_BIO_FLG = 'Y'
                               AND SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.STRTG_EMER_IDY_TYP IN ('C','D','E','F','G','H','I','J','K') THEN '是' --战略性新兴产业
                          WHEN SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.IP_CONC_IDY = 'Y' THEN '是' --知识产权专利密集型产业
                          ELSE '否'
                      END
                ELSE '否'
            END                                            AS SFKJDK, --是否科技贷款
           --A.LOAN_OFR_NO                                   AS XDYGH, --信贷员工号
           NVL(TRIM(A.LOAN_OFR_NO),TRIM(A.OPER_TELLER_ID)) AS XDYGH, --信贷员工号
           CASE WHEN A.RCPT_STAT = 'C01' THEN '结清'
                WHEN A.RCPT_STAT = 'C0201' THEN '核销'
                --WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转出'
                WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转让'  --MODIFY BY LIP 20220520 修改描述
                /*--MOD BY LIP 20240702 逾期里剔除展期未到期的数据，如果展期已到期将统计到逾期里
                WHEN A.RCPT_STAT = 'B' AND A.RENEW_FLG_WDQ = 'Y' THEN '正常'*/
                WHEN A.RCPT_STAT = 'B' THEN '逾期'
                WHEN A.RCPT_STAT = 'A' AND A.OVD_DAYS > 0 THEN '逾期' --MOD BY LIP 20240702 根据逾期天数判断是否为逾期贷款
                WHEN A.RCPT_STAT = 'A' THEN '正常'
                ELSE '其他-' || REPLACE(CODE11.TAR_VALUE_NAME, '其他-','')
            END                                          AS DKZT, --贷款状态
           --''                                            AS BBZ, --备注
           /*ADD BY LIP 20220616
             弱校验 贷款金额不等于0时，应大于等于贷款余额; 这个弱校验统一备注
            “贷款余额包含公允价值变动及利息调整部分，与1104报表口径一致" */
           CASE WHEN A.LOAN_BIZ_TYP = '0602' --MOD BY LIP 20260324
                THEN '该笔为法人账户透支业务，根据《银行业金融机构监管数据标准化规范（2021版）填报口径（第一期）》第1306号答疑，该种业务场景应按 “其他-法人账户透支”填报'
                WHEN CASE WHEN A.LOAN_PROD_ID IN ('203020300001','203030600001','203030600002','204010100002','204010100001') THEN A.BILL_ACT_AMT --转帖现、福费廷的贷款金额取实付金额
                           ELSE A.LOAN_AMT
                      END <
                     CASE WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID NOT LIKE '1301%' THEN NVL(A.LOAN_BAL,0)
                          WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID LIKE '1301%' THEN NVL(A.LOAN_BAL,0) - NVL(A.INT_ADJ,0)
                          ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
                      END
                THEN '贷款余额包含公允价值变动及利息调整部分，与1104报表口径一致'
            END                                          AS BBZ,--备注
           V_MONTH_END_DATEID                            AS CJRQ, --采集日期
           '000'                                         AS DEPT_NO, --部门编号
           '01'                                          AS SRC_SYS_ID, --来源系统ID
           '000000'                                      AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                              AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                          AS ADDRESS, --归属地
           --D.CUST_NM                                     AS KHMC_ORIG, --客户名称（脱敏前）
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                          AS KHMC_ORIG, --客户名称（脱敏前）
           '否'                                          AS KHMC_OTH, --客户是否个人客户
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                          AS GSFZJG, --归属分支机构
           CASE WHEN TRIM(SUB.ENTRS_PAY_OBJ_ACC) IS NOT NULL
                   AND REGEXP_REPLACE(TRIM(SUB.ENTRS_PAY_OBJ_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(SUB.ENTRS_PAY_OBJ_ACC_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(SUB.ENTRS_PAY_OBJ_ACC) IS NOT NULL
                THEN TRIM(SUB.ENTRS_PAY_OBJ_ACC_NM)
                WHEN REGEXP_REPLACE(TRIM(A.ETR_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.ETR_ACC_NM),'(','（'),')','）'),' ','')
                ELSE A.ETR_ACC_NM
            END                                          AS DKRZHM_ORIG, --贷款入账户名（脱敏前） --ADD BY LIP 20260304
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND LENGTH(TRIM(REGEXP_REPLACE(SUB.ENTRS_PAY_OBJ_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN '是'
                WHEN SUB.RCPT_ID IS NOT NULL THEN '否'
                ELSE '否'
            END                                          AS DKRZHM_OTH, --贷款入账户名是否个人 --ADD BY LIP 20260304
           CASE WHEN D.NATL_ECON_DEPT_CL LIKE 'E%' THEN '境外机构'
                WHEN D.NATL_ECON_DEPT_CL IN ('A01','A02') THEN '政府机关'
                WHEN D.CUST_CL = 'C' THEN '事业单位'
                WHEN D.CUST_CL = 'D' THEN '社会团体'
                WHEN D.CUST_CL LIKE 'A%' AND D.ENT_SCALE = 'L' THEN '大型企业'
                WHEN D.CUST_CL LIKE 'A%' AND D.ENT_SCALE = 'M' THEN '中型企业'
                WHEN D.CUST_CL LIKE 'A%' AND D.ENT_SCALE = 'S' THEN '小型企业'
                WHEN D.CUST_CL LIKE 'A%' AND D.ENT_SCALE = 'X' THEN '微型企业'
                ELSE '其他组织机构'
            END                                          AS QYFL, --企业分类 --ADD BY LIP 20260330
           CASE WHEN T1.RCPT_ID IS NOT NULL THEN '是'
                ELSE '否'
            END                                          AS SFCZZFXX --是否存在支付信息 --ADD BY LIP 20260330
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.S_LOAN TC --ADD BY LIP 20240523 参考1104加工逻辑
        ON TC.RCPT_ID = A.RCPT_ID
       AND TC.CBRC_FLG = 'Y'
       --AND TC.DATA_SRC IN ('对公信贷')
       AND TC.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现','对公联合网贷') --MOD BY LIP 20250228
       AND TC.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.S_LOAN_AGR_REL TD --ADD BY LIP 20240523 参考1104加工逻辑
        ON TD.RCPT_ID = A.RCPT_ID
       AND TD.CBRC_FLG = 'Y'
       AND TD.DATA_SRC IN ('对公信贷')
       AND TD.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN LOAN_ENTRS_PAY_SUB SUB --受托支付子表
        ON SUB.RCPT_ID = A.RCPT_ID
       AND A.LOAN_BIZ_TYP NOT LIKE '0205%' --剔除垫款 --ADD BY LIP 20250217 根据严希婧口径调整，剔除垫款的受托记录
       AND A.SUBJ_ID NOT LIKE '13050201%' --福费廷成本 --ADD BY LIP 20250217 根据严希婧口径调整，剔除福费廷成本的受托记录
       AND SUB.RN = 1
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)--科目报送到三级
       AND C.DATA_DT = V_P_DATE
      --LEFT JOIN RRP_MDL.M_LOAN_RP_PLAN_INFO E --贷款还款计划信息
      LEFT JOIN LOAN_RP_PLAN_INFO E --贷款还款计划信息
        ON E.RCPT_ID = A.RCPT_ID
       AND E.REPY_PRD_NUM = A.CURR_PRD /*+ 1*/ --MODIFY BY LIP 20220428 取下期计划 --modify by tangan at 20221229 因为CURR_PRD已经取的是已还款的下一期，所以此处不应该再加1
       --AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.DSBR_MODE
       AND CODE1.SRC_CLASS_CODE = 'D0104' --放款方式
       AND CODE1.TAR_CLASS_CODE = 'D0104' --放款方式
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.LVL5_CL
       AND CODE2.SRC_CLASS_CODE = 'D0005' --五级分类
       AND CODE2.TAR_CLASS_CODE = 'D0005' --五级分类
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE31 --码值配置表
        ON CODE31.SRC_VALUE_CODE = A.GXH_PAY_TYPE
       AND CODE31.SRC_CLASS_CODE = 'CD1072' --还款方式
       AND CODE31.TAR_CLASS_CODE = 'CD1072' --还款方式
       AND CODE31.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.REPY_MODE
       AND CODE3.SRC_CLASS_CODE = 'D0103' --还款方式
       AND CODE3.TAR_CLASS_CODE = 'D0103' --还款方式
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.INT_CALC_MODE
       AND CODE4.SRC_CLASS_CODE = 'D0061' --计息方式
       AND CODE4.TAR_CLASS_CODE = 'D0061' --计息方式
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE5 --码值配置表
        ON CODE5.SRC_VALUE_CODE = A.LOAN_DIR_RGN
       AND CODE5.SRC_CLASS_CODE = 'P0002' --贷款投向地区
       AND CODE5.TAR_CLASS_CODE = 'P0002' --贷款投向地区
       AND CODE5.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE6 --码值配置表
        ON CODE6.SRC_VALUE_CODE = A.NET_LOAN_FLG
       AND CODE6.SRC_CLASS_CODE = 'Z0001' --是否互联网贷款
       AND CODE6.TAR_CLASS_CODE = 'Z0001' --是否互联网贷款
       AND CODE6.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE7 --码值配置表
        --ON CODE7.SRC_VALUE_CODE = A.CBRC_GRN_LOAN_FLG
        ON CODE7.SRC_VALUE_CODE = TC.CBRC_GRN_LOAN_FLG --MOD BY LIP 20250715 根据1104的口径调整
       AND CODE7.SRC_CLASS_CODE = 'Z0001' --是否绿色贷款
       AND CODE7.TAR_CLASS_CODE = 'Z0001' --是否绿色贷款
       AND CODE7.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE8 --码值配置表
        ON CODE8.SRC_VALUE_CODE = A.AGR_REL_LOAN_FLG
       AND CODE8.SRC_CLASS_CODE = 'Z0001' --是否涉农贷款
       AND CODE8.TAR_CLASS_CODE = 'Z0001' --是否涉农贷款
       AND CODE8.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE9 --码值配置表
        ON CODE9.SRC_VALUE_CODE = A.LOAN_BIZ_TYP
       AND CODE9.SRC_CLASS_CODE = 'T0001' --信贷业务种类
       AND CODE9.TAR_CLASS_CODE = 'T0001' --信贷业务种类
       AND CODE9.MOD_FLG = 'EAST'
      /*LEFT JOIN RRP_MDL.CODE_MAP CODE10 --码值配置表
        ON CODE10.SRC_VALUE_CODE = A.LOAN_FRM
       AND CODE10.SRC_CLASS_CODE = 'D0008' --贷款发放类型
       AND CODE10.TAR_CLASS_CODE = 'D0008' --贷款发放类型
       AND CODE10.MOD_FLG = 'EAST'*/
      LEFT JOIN RRP_MDL.CODE_MAP CODE11 --码值配置表
        ON CODE11.SRC_VALUE_CODE = A.RCPT_STAT
       AND CODE11.SRC_CLASS_CODE = 'D0007' --借据状态
       AND CODE11.TAR_CLASS_CODE = 'D0007' --借据状态
       AND CODE11.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
      LEFT JOIN IS_SFCZZFXX T1 --ADD BY LIP 20260330 判断借据是否存在支付信息
        ON T1.RCPT_ID = A.RCPT_ID
     WHERE (A.LOAN_BIZ_TYP NOT LIKE '01%' OR A.LOAN_BIZ_TYP LIKE '90%')
       AND A.LOAN_BIZ_TYP <> '99' --ADD 20221129 LHQ 非标的只有金数和存保用,EAST剔除
       AND A.AD_CSH_FLG = '0' --ADD BY LIP 20230616 剔除过路垫款
       AND A.EAST_FLG = 'Y' --ADD 20230103 LHQ  增加月批次标志
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
    SELECT CJRQ,XDJJH,COUNT(1)
      FROM RRP_EAST.EAST5_504_DGXDYWJJB T
     WHERE CJRQ = V_MONTH_END_DATEID
     GROUP BY CJRQ,XDJJH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_504_DGXDYWJJB(CJRQ,XDJJH)数据重复';
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

END ETL_EAST5_504_DGXDYWJJB;
/

