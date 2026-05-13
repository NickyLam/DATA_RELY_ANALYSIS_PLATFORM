CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_PTY_CORP(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_PTY_CORP
  *  功能描述：公司当事人
  *  创建日期：20221222
  *  开发人员：梅炜
  *  来源表： IML.V_PTY_CORP
  *  目标表： O_IML_PTY_CORP
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_PTY_CORP'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_PTY_CORP ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_PTY_CORP';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-公司当事人';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_PTY_CORP
  (
        PARTY_ID  --当事人编号
        ,LP_ID  --法人编号
        ,DEPOSITR_CATE_CD  --存款人类别代码
        ,CORP_NAME  --公司名称
        ,CORP_EN_NAME  --公司英文名称
        ,SOCI_CRDT_CD  --统一社会信用代码
        ,CURR_CD  --币种代码
        ,RGST_CAP  --注册资金
        ,RGST_ADDR  --注册地址
        ,CTY_RG_CD  --国家和地区代码
        ,INDUS_TYPE_CD  --行业类型代码
        ,ECON_CHAR_CD  --经济性质代码
        ,TAXPAYER_IDTFY_NUM  --纳税人识别号
        ,CORP_TYPE_CD  --企业类型代码
        ,TAX_STAMENT_FLG  --取得税收居民取得自证声明标志
        ,TAX_ORG_CATE_CD  --税收机构类别代码
        ,TAX_RESDNT_CTY_CD  --税收居民国家代码组合
        ,TAX_RESDNT_IDTI_CD  --税收居民身份代码
        ,EMPLY_QTTY  --企业员工人数
        ,FIN_SUBSIDY_INCO_SRC_CD  --财政补助收入来源代码
        ,STRATEGY_CAMP_CUST_NO  --策略营销客户号
        ,INS_ADJ_TYPE_CD  --产业结构调整类型代码
        ,SINGLE_LMT  --单一限额
        ,SINGLE_LP_FLG  --独立法人标志
        ,HIGH_NEW_TECH_CORP_FLG  --高新技术企业标志
        ,ITAU_FLG  --工业转型升级标志
        ,RELA_PARTY_FLG  --关联方标志
        ,RELA_GROUP_TYPE_CD  --关联集团类型代码
        ,ORG_TYPE_CD  --机构类型代码
        ,ORG_STATUS_CD  --机构状态代码
        ,GROUP_CUST_FLG  --集团客户标志
        ,WEIGHT_RISK_ASSET_CUST_CLS_CD  --加权风险资产客户分类代码
        ,CBRC_SB_FLG  --银监小企业标志
        ,ECON_TYPE_CD  --登记注册类型代码
        ,OPER_RANGE  --经营范围
        ,CUST_SEV_UGD_CLS_CD  --客户服务升级分类代码
        ,HOLD_TYPE_CD  --控股类型代码
        ,OFF_SHORE_CUST_FLG  --离岸客户标志
        ,SUBJ_ORG_NAME  --隶属机构名称
        ,PRIT_ETP_FLG  --民营企业标志
        ,CTYSD_CORP_FLG  --农村城市标志
        ,CORP_FOUND_DT  --企业成立日期
        ,CORP_SIZE_CD  --企业规模代码
        ,CORP_SIZE_CD_INTNAL  --企业规模代码_内部
        ,TA_CUST_SIZE  --商圈客户规模
        ,TA_CUST_INDUS_STATUS  --商圈客户行业地位
        ,LIST_CORP_TYPE_CD  --上市类型代码
        ,LIST_CORP_FLG  --上市企业标志
        ,CRDT_STRATEGY_CD  --授信策略代码
        ,CRDT_CUST_FLG  --授信客户标志
        ,BEL_THI_FLG  --属于两高行业标志
        ,RGST_DT  --注册日期
        ,ORGNZ_TYPE_CD  --组织机构类型代码
        ,ORGNZ_TYPE_SUBDV_CD  --组织机构类型细分代码
        ,ECON_ORGNZ_FORM_CD  --控股类型代码
        ,TRAST_TAX_REGI_CERT_FLG  --办理税务登记证标志
        ,FIN_STAT_TYPE_CD  --财务报表类型代码
        ,JNOR_COG_OVER_NUMBER  --大专以上人数
        ,CTY_KEY_ENTERP_FLG  --国家重点企业标志
        ,NATNAL_ECON_DEPT_TYPE_CD  --国民经济部门类型代码
        ,INDUS_TYPE_CD_LEVEL5_CLS  --行业类型代码_五级分类
        ,INDUS_TYPE_CD_CRDT_RATING  --行业类型代码_信用评级
        ,ORG_SUBJ  --机构隶属
        ,GROUP_CORP_FLG  --集团公司标志
        ,GROUP_CUST_ID  --集团编号
        ,RESDNT_FLG  --居民标志
        ,OPEN_CAP  --开办资金
        ,CUST_LEV_CD  --客户级别代码
        ,RETIRE_NUMBER  --离退休人数
        ,SUPER_DIRECTOR_DEPT  --上级主管部门
        ,CAUSE_LP_SIZE_OR_LEV_CD  --事业法人规模或级别代码
        ,CAUSE_LP_CUST_TYPE_CD  --事业法人客户类型代码
        ,BAL_PAY_WAY_CD  --收支方式代码
        ,SYS_IN_CUST_FLG  --系统内客户标志
        ,LMT_OR_ENCRGE_INDUS_CD  --限制或鼓励行业代码
        ,HAVE_HXB_SHARE_QTTY  --拥有我行股份数量
        ,HAVE_BOD_FLG  --有董事会标志
        ,BUDGET_FORM_CD  --预算形式代码
        ,GREEN_CRDT_CUST_FLG  --绿色信贷标志
        ,ARAF_FLG  --三农标志
        ,CORP_SIZE_CD_CPES  --企业规模代码_票交所
        ,INDUS_TYPE_CD_CPES  --行业类型代码_票交所
        ,ORGNZ_CD  --组织机构代码
        ,CORP_PARTY_TYPE_CD  --对公当事人类型代码
        ,RG_CD  --注册行政区划代码
        ,INDUS_TYPE_CD_CRDTC  --行业类型代码_征信
        ,INDUS_CATEGY_CD_CRDTC  --行业门类代码_征信
        ,TAX_NUM_NULL_RS_DESCB  --纳税人识别号空值原因描述
        ,NON_REC_RS  --不良记录原因
        ,BLKLIST_CUST_FLG  --黑名单客户标志
        ,BLKLIST_RGST_DT  --上黑名单日期
        ,BLKLIST_RS  --上黑名单原因
        ,LOAN_CARD_NO  --贷款卡号
        ,STOCK_CD  --股票代码
        ,CITIZEN_TREAT_FLG  --国民待遇标志
        ,FIR_SETUP_CRDT_RELA_DT  --首次建立信贷关系日期
        ,MGER_MEMBER_NUMBER  --管理人员人数
        ,DIGIT_ECON_INDUS_CD  --数字经济行业代码
        ,STRTG_NEW_INDUS_TYPE_CD  --战略新兴产业类型代码
        ,SHARE_RATIO  --持股比例
        ,SUPER_ORGNZ_CD  --上级机构组织机构代码
        ,SUPER_UNIFY_SOCI_CRDT_CD  --上级机构统一社会信用代码
        ,DIRECTOR_CORP_RGST_CURR_CD  --主管单位注册币种代码
        ,DIRECTOR_CORP_RGST_AMT  --主管单位注册金额
        ,SHARD_TYPE_CD  --股东类型代码
        ,CTRLER_TYPE_CD  --控制人类型代码
        ,PROPERTY_TYPE_CD  --产业类型代码
        ,ROLE_TYPE_CD  --角色类型代码
        ,LP_ORG_NAME  --法人机构名称
        ,LP_ORG_TYPE_CD  --法人机构类型代码
        ,LP_ORG_CUST_ID  --法人机构客户编号
        ,SUPER_ORG_CUST_ID  --上级机构客户编号
        ,OPEN_ACCT_CHN_CD  --开户渠道代码
        ,CUST_OWNSP_TYPE_CD  --客户所有制类型代码
        ,MANG_SITE_DIST_CD  --经营所在地行政区划代码
        ,START_DT  --开始时间
        ,END_DT  --结束时间
        ,ID_MARK  --增删标志
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳

    )
    SELECT
        PARTY_ID  --当事人编号
        ,LP_ID  --法人编号
        ,DEPOSITR_CATE_CD  --存款人类别代码
        ,CORP_NAME  --公司名称
        ,CORP_EN_NAME  --公司英文名称
        ,SOCI_CRDT_CD  --统一社会信用代码
        ,CURR_CD  --币种代码
        ,RGST_CAP  --注册资金
        ,RGST_ADDR  --注册地址
        ,CTY_RG_CD  --国家和地区代码
        ,INDUS_TYPE_CD  --行业类型代码
        ,ECON_CHAR_CD  --经济性质代码
        ,TAXPAYER_IDTFY_NUM  --纳税人识别号
        ,CORP_TYPE_CD  --企业类型代码
        ,TAX_STAMENT_FLG  --取得税收居民取得自证声明标志
        ,TAX_ORG_CATE_CD  --税收机构类别代码
        ,TAX_RESDNT_CTY_CD  --税收居民国家代码组合
        ,TAX_RESDNT_IDTI_CD  --税收居民身份代码
        ,EMPLY_QTTY  --企业员工人数
        ,FIN_SUBSIDY_INCO_SRC_CD  --财政补助收入来源代码
        ,STRATEGY_CAMP_CUST_NO  --策略营销客户号
        ,INS_ADJ_TYPE_CD  --产业结构调整类型代码
        ,SINGLE_LMT  --单一限额
        ,SINGLE_LP_FLG  --独立法人标志
        ,HIGH_NEW_TECH_CORP_FLG  --高新技术企业标志
        ,ITAU_FLG  --工业转型升级标志
        ,RELA_PARTY_FLG  --关联方标志
        ,RELA_GROUP_TYPE_CD  --关联集团类型代码
        ,ORG_TYPE_CD  --机构类型代码
        ,ORG_STATUS_CD  --机构状态代码
        ,GROUP_CUST_FLG  --集团客户标志
        ,WEIGHT_RISK_ASSET_CUST_CLS_CD  --加权风险资产客户分类代码
        ,CBRC_SB_FLG  --银监小企业标志
        ,ECON_TYPE_CD  --登记注册类型代码
        ,OPER_RANGE  --经营范围
        ,CUST_SEV_UGD_CLS_CD  --客户服务升级分类代码
        ,HOLD_TYPE_CD  --控股类型代码
        ,OFF_SHORE_CUST_FLG  --离岸客户标志
        ,SUBJ_ORG_NAME  --隶属机构名称
        ,PRIT_ETP_FLG  --民营企业标志
        ,CTYSD_CORP_FLG  --农村城市标志
        ,CORP_FOUND_DT  --企业成立日期
        ,CORP_SIZE_CD  --企业规模代码
        ,CORP_SIZE_CD_INTNAL  --企业规模代码_内部
        ,TA_CUST_SIZE  --商圈客户规模
        ,TA_CUST_INDUS_STATUS  --商圈客户行业地位
        ,LIST_CORP_TYPE_CD  --上市类型代码
        ,LIST_CORP_FLG  --上市企业标志
        ,CRDT_STRATEGY_CD  --授信策略代码
        ,CRDT_CUST_FLG  --授信客户标志
        ,BEL_THI_FLG  --属于两高行业标志
        ,RGST_DT  --注册日期
        ,ORGNZ_TYPE_CD  --组织机构类型代码
        ,ORGNZ_TYPE_SUBDV_CD  --组织机构类型细分代码
        ,ECON_ORGNZ_FORM_CD  --控股类型代码
        ,TRAST_TAX_REGI_CERT_FLG  --办理税务登记证标志
        ,FIN_STAT_TYPE_CD  --财务报表类型代码
        ,JNOR_COG_OVER_NUMBER  --大专以上人数
        ,CTY_KEY_ENTERP_FLG  --国家重点企业标志
        ,NATNAL_ECON_DEPT_TYPE_CD  --国民经济部门类型代码
        ,INDUS_TYPE_CD_LEVEL5_CLS  --行业类型代码_五级分类
        ,INDUS_TYPE_CD_CRDT_RATING  --行业类型代码_信用评级
        ,ORG_SUBJ  --机构隶属
        ,GROUP_CORP_FLG  --集团公司标志
        ,GROUP_CUST_ID  --集团编号
        ,RESDNT_FLG  --居民标志
        ,OPEN_CAP  --开办资金
        ,CUST_LEV_CD  --客户级别代码
        ,RETIRE_NUMBER  --离退休人数
        ,SUPER_DIRECTOR_DEPT  --上级主管部门
        ,CAUSE_LP_SIZE_OR_LEV_CD  --事业法人规模或级别代码
        ,CAUSE_LP_CUST_TYPE_CD  --事业法人客户类型代码
        ,BAL_PAY_WAY_CD  --收支方式代码
        ,SYS_IN_CUST_FLG  --系统内客户标志
        ,LMT_OR_ENCRGE_INDUS_CD  --限制或鼓励行业代码
        ,HAVE_HXB_SHARE_QTTY  --拥有我行股份数量
        ,HAVE_BOD_FLG  --有董事会标志
        ,BUDGET_FORM_CD  --预算形式代码
        ,GREEN_CRDT_CUST_FLG  --绿色信贷标志
        ,ARAF_FLG  --三农标志
        ,CORP_SIZE_CD_CPES  --企业规模代码_票交所
        ,INDUS_TYPE_CD_CPES  --行业类型代码_票交所
        ,ORGNZ_CD  --组织机构代码
        ,CORP_PARTY_TYPE_CD  --对公当事人类型代码
        ,RG_CD  --注册行政区划代码
        ,INDUS_TYPE_CD_CRDTC  --行业类型代码_征信
        ,INDUS_CATEGY_CD_CRDTC  --行业门类代码_征信
        ,TAX_NUM_NULL_RS_DESCB  --纳税人识别号空值原因描述
        ,NON_REC_RS  --不良记录原因
        ,BLKLIST_CUST_FLG  --黑名单客户标志
        ,BLKLIST_RGST_DT  --上黑名单日期
        ,BLKLIST_RS  --上黑名单原因
        ,LOAN_CARD_NO  --贷款卡号
        ,STOCK_CD  --股票代码
        ,CITIZEN_TREAT_FLG  --国民待遇标志
        ,FIR_SETUP_CRDT_RELA_DT  --首次建立信贷关系日期
        ,MGER_MEMBER_NUMBER  --管理人员人数
        ,DIGIT_ECON_INDUS_CD  --数字经济行业代码
        ,STRTG_NEW_INDUS_TYPE_CD  --战略新兴产业类型代码
        ,SHARE_RATIO  --持股比例
        ,SUPER_ORGNZ_CD  --上级机构组织机构代码
        ,SUPER_UNIFY_SOCI_CRDT_CD  --上级机构统一社会信用代码
        ,DIRECTOR_CORP_RGST_CURR_CD  --主管单位注册币种代码
        ,DIRECTOR_CORP_RGST_AMT  --主管单位注册金额
        ,SHARD_TYPE_CD  --股东类型代码
        ,CTRLER_TYPE_CD  --控制人类型代码
        ,PROPERTY_TYPE_CD  --产业类型代码
        ,ROLE_TYPE_CD  --角色类型代码
        ,LP_ORG_NAME  --法人机构名称
        ,LP_ORG_TYPE_CD  --法人机构类型代码
        ,LP_ORG_CUST_ID  --法人机构客户编号
        ,SUPER_ORG_CUST_ID  --上级机构客户编号
        ,OPEN_ACCT_CHN_CD  --开户渠道代码
        ,CUST_OWNSP_TYPE_CD  --客户所有制类型代码
        ,MANG_SITE_DIST_CD  --经营所在地行政区划代码
        ,START_DT  --开始时间
        ,END_DT  --结束时间
        ,ID_MARK  --增删标志
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_PTY_CORP  --视图-公司当事人
;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_O_IML_PTY_CORP;
/

