CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_CORP_CUST_BASIC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_CORP_CUST_BASIC_INFO
  *  功能描述：对公客户基本信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CORP_CUST_BASIC_INFO
  *  目标表： O_ICL_CMM_CORP_CUST_BASIC_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20221615           修改参数
                3    20231130  HYF      增加客户号非空过滤
                4    20250327  YJY      新增存款类客户标志、贷款类客户标志
                5    20250508  YJY      新增绿色信贷分类_新版代码
                6    20250825  YJY      新增集团类型代码
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_CORP_CUST_BASIC_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_CORP_CUST_BASIC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-对公客户基本信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
    (  ETL_DT			          --数据日期
      ,LP_ID			          --法人编号
      ,CUST_ID		          --客户编号
      ,CUST_NAME			      --客户名称
      ,CUST_EN_NAME			    --客户英文名称
      ,CUST_KIND_CD			    --客户种类代码
      ,OPEN_ACCT_DT			    --开户日期
      ,BELONG_ORG_ID			  --所属机构编号
      ,OPEN_ACCT_ORG_ID			--开户机构编号
      ,OPEN_ACCT_TELLER_ID	--开户柜员编号
      ,OPEN_ACCT_CHN_CD			--开户渠道代码
      ,CREATE_CHN_CD			  --创建渠道代码
      ,CUST_MGR_ID			    --客户经理编号
      ,CUST_TYPE_CD			    --客户类型代码
      ,CRDT_CUST_TYPE_CD		--信贷客户类型代码
      ,CUST_LEV_CD			    --客户级别代码
      ,DEPOSITR_CATE_CD			--存款人类别代码
      ,BAL_PAY_WAY_CD			  --收支方式代码
      ,CUST_STATUS_CD			  --客户状态代码
      ,CORP_ANL_INCO			  --企业年收入
      ,CORP_YEAR_BUS_LMT		--企业年营业额
      ,CORP_FOUND_DT			  --企业成立日期
      ,CORP_SIZE_CD			    --企业规模代码
      ,INDUS_CATEGY_CD			--行业门类代码
      ,INDUS_TYPE_CD			  --行业类型代码
      ,INDUS_TYPE_CD_CRDTC	--行业类型代码_征信
      ,PHONE_CRDTC			    --联系电话_征信
      ,CORP_TYPE_CD			    --企业类型代码
      ,CTY_RG_CD			      --国家和地区代码
      ,RG_CD			          --地区代码
      ,ECON_CHAR_CD			    --经济性质代码
      ,ECON_TYPE_CD			    --经济类型代码
      ,ORGNZ_CD			        --组织机构代码
      ,ORGNZ_TYPE_CD			  --组织机构类型代码
      ,NATNAL_ECON_DEPT_TYPE_CD		--国民经济部门类型代码
      ,INDUS_LEVEL5_CLS_CD	--行业五级分类代码
      ,INDUS_CRDT_RATING_CD	--行业信用评级代码
      ,SOCI_CRDT_CD			    --统一社会信用代码
      ,BUS_LICS_NUM			    --营业执照号
      ,BUS_LICS_EXP_DT			--营业执照到期日期
      ,NATION_TAX_RGST_CERT_NUM	--国税登记证号码
      ,LOCAL_TAX_RGST_CERT_NUM	--地税登记证号码
      ,FIN_LICS_NUM			    --金融许可证号
      ,PBC_PAY_BANK_NO			--人行支付行号
      ,ECON_ORGNZ_FORM_CD		--经济组织形式代码
      ,LOAN_CARD_NO			    --贷款卡号
      ,STOCK_CD			        --股票代码
      ,OPER_RANGE			      --经营范围
      ,EMPLY_QTTY			      --员工数量
      ,CURR_CD			        --币种代码
      ,RGST_CAP			        --注册资金
      ,RGST_ADDR			      --注册地址
      ,RGST_DT			        --注册日期
      ,RGSTION_CD			      --登记注册代码
      ,MANG_FIELD_PROP_CD		--经营场地所有权代码
      ,CORP_RGSTION_TYPE		--企业登记注册类型
      ,PAID_IN_CAPITAL			--实收资本
      ,PAID_IN_CAPITAL_CURR_CD		--实收资本币种代码
      ,INVTOR_CTY_CD			  --投资方国家代码
      ,MANG_FIELD_AREA			--经营场地面积
      ,ASSET_TOT			      --资产总额
      ,NET_ASSET_TOT			  --净资产总额
      ,SINGLE_LP_FLG			  --独立法人标志
      ,HIGH_NEW_TECH_CORP_FLG		--高新技术企业标志
      ,RELA_PARTY_FLG			  --关联方标志
      ,RELA_GROUP_TYPE_CD		--关联集团类型代码
      ,LP_ORG_NAME			    --法人机构名称
      ,LP_ORG_TYPE_CD			  --法人机构类型代码
      ,LP_ORG_CUST_ID			  --法人机构客户编号
      ,GROUP_CUST_FLG			  --集团客户标志
      ,CBRC_SB_FLG			    --银监小企业标志
      ,LABOR_INTE_FLG			  --劳动密集型标志
      ,HOLD_TYPE_CD			    --控股类型代码
      ,OFF_SHORE_CUST_FLG		--离岸客户标志
      ,PRIT_ETP_FLG			    --民营企业标志
      ,CTYSD_CORP_FLG			  --农村企业标志
      ,CORP_GROW_STAGE_CD		--企业成长阶段代码
      ,LIST_CORP_TYPE_CD		--上市公司类型代码
      ,STRATE_NEW_INDUS_CLS_CD	--战略性新兴产业分类代码
      ,LIST_CORP_FLG			  --上市企业标志
      ,STRTG_CUST_FLG			  --战略客户标志
      ,OPEN_CAP			        --开办资金
      ,CRDT_CUST_FLG			  --授信客户标志
      ,STAMENT_FLG			    --自证声明标志
      ,TAX_ORG_CATE_CD			--税收机构类别代码
      ,TAX_RESDNT_CTY_CD		--税收居民国家代码
      ,TAX_RESDNT_IDTI_CD		--税收居民身份代码
      ,BASIC_ACCT_OPEN_BANK_NAME	--基本账户开户行名称
      ,BASIC_ACCT_ACCT_NUM	--基本账户账号
      ,TAX_NUM			        --纳税人识别号
      ,TAX_NUM_NULL_RS_DESCB	--纳税人识别号空值原因描述
      ,BEL_THI_FLG			    --属于两高行业标志
      ,TRAST_TAX_REGI_CERT_FLG	--办理税务登记证标志
      ,CTY_KEY_ENTERP_FLG		--国家重点企业标志
      ,GROUP_CORP_FLG			  --集团公司标志
      ,GROUP_CUST_ID			  --集团客户编号
      ,GROUP_PARENT_CORP_ID	--集团母公司编号
      ,LMT_OR_ENCRGE_INDUS_CD	--限制或鼓励行业代码
      ,HAVE_BOD_FLG			    --有董事会标志
      ,GREEN_CRDT_CUST_FLG	--绿色信贷客户标志
      ,GREEN_CRDT_CLS_CD		--绿色信贷分类代码
      ,SCI_TECH_CORP_CLS_CD	--科技型企业分类代码
      ,SCI_TECH_CORP_IDTFY_DT	--科技型企业认定日期
      ,EDU_HEA_FLG			    --文教健康标志
      ,INC_FLG			        --普惠标志
      ,ARAF_FLG			        --三农标志
      ,IS_MX_MGMT_RIGH_FLG	--有无进出口经营权标志
      ,ESCP_DEBT_CORP_FLG		--逃废债企业标志
      ,IS_MX_OPER_ITEM_FLG	--有无进出口经营项标志
      ,RESDNT_FLG			      --居民标志
      ,DOM_OVERS_FLG			  --境内外标志
      ,WORK_ADDR			      --办公地址
      ,WORK_ADDR_ZIP_CD			--办公地址邮政编码
      ,POSTA_ADDR			      --通讯地址
      ,POSTA_ADDR_ZIP_CD		--通讯地址邮政编码
      ,PROD_MANG_ADDR			  --生产经营地址
      ,PROD_MANG_ADDR_ZIP_CD	--生产经营地址邮政编码
      ,MANG_SITE_CD		    	--经营所在地区代码
      ,CRDT_CUST_RISK_RATING_CD		--信贷客户风险评级代码
      ,CRDT_CUST_RISK_RATING_START_DT	--信贷客户风险评级开始日期
      ,CRDT_CUST_RISK_RATING_EXP_DT		--信贷客户风险评级到期日期
      ,OWNSP_TYPE_CD			  --所有制类型代码
      ,CORP_CLOSE_FLG			  --企业关停标志
      ,GOVER_FIN_PLAT_FLG		--政府融资平台标志
      ,SHORT_CHECK_BLKLIST_FLG	--空头支票黑名单标志
      ,FIR_LON_DT			      --首贷日期
      ,ORGNZ_SURVIV_STATUS_CD --组织机构存续状态代码
      ,CORP_IDTI_IDF_TYPE_CD  --企业身份标识类型代码
      ,MAJOR_CONTRIOR_CNT		--主要出资人个数
      ,ACTL_CTRLER_CNT			--实际控制人个数
      ,FIN_DEPT_PHONE			  --财务部门联系电话
      ,JOB_CD			          --任务代码
      ,DEP_CLASS_CUST_FLG   --存款类客户标志  ADD BY YJY 20250327
      ,LOAN_CLASS_CUST_FLG  --贷款类客户标志  ADD BY YJY 20250327
      ,GREEN_CRDT_CLS_NEW   --绿色信贷分类_新版代码 ADD BY YJY 20250508
      ,GROUP_TYPE_CD        --集团类型代码  ADD BY YJY 20250825
     )
  SELECT 
         TO_DATE(V_P_DATE,'YYYYMMDD')    AS ETL_DT			--数据日期
        ,LP_ID			             --法人编号
        ,CUST_ID			           --客户编号
        ,CUST_NAME			         --客户名称
        ,CUST_EN_NAME			       --客户英文名称
        ,CUST_KIND_CD			       --客户种类代码
        ,OPEN_ACCT_DT			       --开户日期
        ,BELONG_ORG_ID			     --所属机构编号
        ,OPEN_ACCT_ORG_ID			   --开户机构编号
        ,OPEN_ACCT_TELLER_ID		 --开户柜员编号
        ,OPEN_ACCT_CHN_CD			   --开户渠道代码
        ,CREATE_CHN_CD			     --创建渠道代码
        ,CUST_MGR_ID			       --客户经理编号
        ,CUST_TYPE_CD			       --客户类型代码
        ,CRDT_CUST_TYPE_CD			 --信贷客户类型代码
        ,CUST_LEV_CD			       --客户级别代码
        ,DEPOSITR_CATE_CD			   --存款人类别代码
        ,BAL_PAY_WAY_CD			     --收支方式代码
        ,CUST_STATUS_CD			     --客户状态代码
        ,CORP_ANL_INCO			     --企业年收入
        ,CORP_YEAR_BUS_LMT			 --企业年营业额
        ,CORP_FOUND_DT			     --企业成立日期
        ,CORP_SIZE_CD			       --企业规模代码
        ,INDUS_CATEGY_CD			   --行业门类代码
        ,INDUS_TYPE_CD			     --行业类型代码
        ,INDUS_TYPE_CD_CRDTC		 --行业类型代码_征信
        ,PHONE_CRDTC			       --联系电话_征信
        ,CORP_TYPE_CD			       --企业类型代码
        ,CTY_RG_CD			         --国家和地区代码
        ,RG_CD			             --地区代码
        ,ECON_CHAR_CD			       --经济性质代码
        ,ECON_TYPE_CD			       --经济类型代码
        ,ORGNZ_CD			           --组织机构代码
        ,ORGNZ_TYPE_CD			     --组织机构类型代码
        ,NATNAL_ECON_DEPT_TYPE_CD	--国民经济部门类型代码
        ,INDUS_LEVEL5_CLS_CD			--行业五级分类代码
        ,INDUS_CRDT_RATING_CD			--行业信用评级代码
        ,REPLACE(SOCI_CRDT_CD,'　','')	--统一社会信用代码
        ,BUS_LICS_NUM			       --营业执照号
        ,BUS_LICS_EXP_DT			   --营业执照到期日期
        ,NATION_TAX_RGST_CERT_NUM			--国税登记证号码
        ,LOCAL_TAX_RGST_CERT_NUM --地税登记证号码
        ,FIN_LICS_NUM			       --金融许可证号
        ,PBC_PAY_BANK_NO			   --人行支付行号
        ,ECON_ORGNZ_FORM_CD			 --经济组织形式代码
        ,LOAN_CARD_NO			       --贷款卡号
        ,STOCK_CD			           --股票代码
        ,OPER_RANGE			         --经营范围
        ,EMPLY_QTTY			         --员工数量
        ,CURR_CD			           --币种代码
        ,RGST_CAP			           --注册资金
        ,RGST_ADDR			         --注册地址
        ,RGST_DT			           --注册日期
        ,RGSTION_CD			         --登记注册代码
        ,MANG_FIELD_PROP_CD			 --经营场地所有权代码
        ,CORP_RGSTION_TYPE			 --企业登记注册类型
        ,PAID_IN_CAPITAL			   --实收资本
        ,PAID_IN_CAPITAL_CURR_CD --实收资本币种代码
        ,INVTOR_CTY_CD			     --投资方国家代码
        ,MANG_FIELD_AREA			   --经营场地面积
        ,ASSET_TOT			         --资产总额
        ,NET_ASSET_TOT			     --净资产总额
        ,SINGLE_LP_FLG			     --独立法人标志
        ,HIGH_NEW_TECH_CORP_FLG	 --高新技术企业标志
        ,RELA_PARTY_FLG			     --关联方标志
        ,RELA_GROUP_TYPE_CD			 --关联集团类型代码
        ,LP_ORG_NAME			       --法人机构名称
        ,LP_ORG_TYPE_CD			     --法人机构类型代码
        ,LP_ORG_CUST_ID			     --法人机构客户编号
        ,GROUP_CUST_FLG			     --集团客户标志
        ,CBRC_SB_FLG			       --银监小企业标志
        ,LABOR_INTE_FLG			     --劳动密集型标志
        ,HOLD_TYPE_CD			       --控股类型代码
        ,OFF_SHORE_CUST_FLG			 --离岸客户标志
        ,PRIT_ETP_FLG			       --民营企业标志
        ,CTYSD_CORP_FLG			     --农村企业标志
        ,CORP_GROW_STAGE_CD			 --企业成长阶段代码
        ,LIST_CORP_TYPE_CD			 --上市公司类型代码
        ,STRATE_NEW_INDUS_CLS_CD --战略性新兴产业分类代码
        ,LIST_CORP_FLG			     --上市企业标志
        ,STRTG_CUST_FLG			     --战略客户标志
        ,OPEN_CAP			           --开办资金
        ,CRDT_CUST_FLG			     --授信客户标志
        ,STAMENT_FLG			       --自证声明标志
        ,TAX_ORG_CATE_CD			   --税收机构类别代码
        ,TAX_RESDNT_CTY_CD			 --税收居民国家代码
        ,TAX_RESDNT_IDTI_CD			 --税收居民身份代码
        ,BASIC_ACCT_OPEN_BANK_NAME			--基本账户开户行名称
        ,BASIC_ACCT_ACCT_NUM		 --基本账户账号
        ,TAX_NUM			           --纳税人识别号
        ,TAX_NUM_NULL_RS_DESCB	 --纳税人识别号空值原因描述
        ,BEL_THI_FLG			       --属于两高行业标志
        ,TRAST_TAX_REGI_CERT_FLG --办理税务登记证标志
        ,CTY_KEY_ENTERP_FLG			 --国家重点企业标志
        ,GROUP_CORP_FLG			     --集团公司标志
        ,GROUP_CUST_ID			     --集团客户编号
        ,GROUP_PARENT_CORP_ID		 --集团母公司编号
        ,LMT_OR_ENCRGE_INDUS_CD	 --限制或鼓励行业代码
        ,HAVE_BOD_FLG			       --有董事会标志
        ,GREEN_CRDT_CUST_FLG		 --绿色信贷客户标志
        ,GREEN_CRDT_CLS_CD			 --绿色信贷分类代码
        ,SCI_TECH_CORP_CLS_CD		 --科技型企业分类代码
        ,SCI_TECH_CORP_IDTFY_DT	 --科技型企业认定日期
        ,EDU_HEA_FLG			       --文教健康标志
        ,INC_FLG			           --普惠标志
        ,ARAF_FLG			           --三农标志
        ,IS_MX_MGMT_RIGH_FLG		 --有无进出口经营权标志
        ,ESCP_DEBT_CORP_FLG			 --逃废债企业标志
        ,IS_MX_OPER_ITEM_FLG		 --有无进出口经营项标志
        ,RESDNT_FLG			         --居民标志
        ,DOM_OVERS_FLG			     --境内外标志
        ,WORK_ADDR			         --办公地址
        ,WORK_ADDR_ZIP_CD			   --办公地址邮政编码
        ,POSTA_ADDR			         --通讯地址
        ,POSTA_ADDR_ZIP_CD			 --通讯地址邮政编码
        ,PROD_MANG_ADDR			     --生产经营地址
        ,PROD_MANG_ADDR_ZIP_CD	 --生产经营地址邮政编码
        ,MANG_SITE_CD			       --经营所在地区代码
        ,CRDT_CUST_RISK_RATING_CD			--信贷客户风险评级代码
        ,CRDT_CUST_RISK_RATING_START_DT		--信贷客户风险评级开始日期
        ,CRDT_CUST_RISK_RATING_EXP_DT			--信贷客户风险评级到期日期
        ,OWNSP_TYPE_CD			     --所有制类型代码
        ,CORP_CLOSE_FLG			     --企业关停标志
        ,GOVER_FIN_PLAT_FLG			 --政府融资平台标志
        ,SHORT_CHECK_BLKLIST_FLG --空头支票黑名单标志
        ,FIR_LON_DT			         --首贷日期
        ,ORGNZ_SURVIV_STATUS_CD	 --组织机构存续状态代码
        ,CORP_IDTI_IDF_TYPE_CD	 --企业身份标识类型代码
        ,MAJOR_CONTRIOR_CNT			 --主要出资人个数
        ,ACTL_CTRLER_CNT			   --实际控制人个数
        ,FIN_DEPT_PHONE			     --财务部门联系电话
        ,JOB_CD			             --任务代码
        ,DEP_CLASS_CUST_FLG      --存款类客户标志  ADD BY YJY 20250327
        ,LOAN_CLASS_CUST_FLG     --贷款类客户标志  ADD BY YJY 20250327
        ,GREEN_CRDT_CLS_NEW      --绿色信贷分类_新版代码 ADD BY YJY 20250508
        ,GROUP_TYPE_CD        --集团类型代码  ADD BY YJY 20250825
    FROM ICL.V_CMM_CORP_CUST_BASIC_INFO     --视图-对公客户基本信息
   WHERE TRIM(CUST_ID) IS NOT NULL   --ADD BY HYF 20231130
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    V_ENDTIME   := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_CORP_CUST_BASIC_INFO;
/

