CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN
  *  功能描述：贷款业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：    M_BILL_INFO
  *              M_CPTL_AST_INFO
  *              M_CPTL_REPO_AST_INFO
  *              M_CRDT_LMT_INFO
  *              M_CUST_CORP_INFO
  *              M_GUA_CONT_INFO
  *              M_GUA_REL_BSN_CONT
  *  目标表：    S_LOAN
  *  配置表：
  *  修改情况：
     序号  修改日期  修改人   修改原因
  *   1    20221005  MW       修改贷款期限逻辑
  *   2    20221107  HULJ     新增字段资产转让日期
  *   3    20221122  于敬艺   新增法人机构客户编号，用于去票据转贴部分企业规模
  *   4    20221124  LIUYU    新增字段逻辑 贷款余额净值，调整格式
  *   5    20221125  WYZ      新增字段 原始期限类型
  *   6    20221128  XUFEI    修改数据范围，剔除贷款转让数据，修改担保方式逻辑，从合同表出数,新增子担保方式,贷款用途
  *   7    20221201  HYF      剔除同业数据只保留贷款数据,修改联合网贷还款频率，按月的03改为M,其他改为-
  *                           修改粤港澳大湾区标志，自由贸易区标志
  *   8    20221202  于敬艺   新增PBOC客户分类、CBRC客户分类字段判断是否企业
  *   9    20221207  于敬艺   修改无还本续贷的口径，从零售合同表直取贷款发生类型进行判断
  *                           新增年化收益字段
  *   10   20221209  于敬艺   修改关于人行是否企业的口径：报送当期该客户名下有未结清的借据，优先取业务的台账分类，其余按照新口径划分。如果当期该客户已全部结清后又新发放的贷款，直接按照监管新口径划分。
  *   11   20230103  于敬艺   新增经营授信总额、消费授信总额
  *   12   20230109  于敬艺   新增放款时农户标志，用于S7103当年累计值
  *   13   20230109  HYF      新增统计担保方式
  *   14   20230215  于敬艺   修改高技术产业、数字经济核心产业、知识产权密集型产业，对公部分从补录表出，对私部分从系统出
  *   15   20220217  luzm     增加零售部分战略新兴产业
  *   16   20230220   于敬艺  修改高新技术企业标志、科技型企业标志、科创企业标志
  *   17   20230220    HYF    修改联合网贷放款日期，将上年末1231的日期改为当年年初0101
  *   18   20230222   于敬艺  添加S7101'其他个人非农户标识' ，与禹晴确认，零售贷款判断客户性质为‘其他无营业执照负责人’且为非农户的数据，
  *                           网商贷判断客群经营剔除‘个体工商户’和‘小微企业主’且是否有效工商信息为‘否’的数据
  *   19   20230227   HYF     核销和转让科目的贷款借据余额及净值置为0
  *   20   20230228   HYF     修改居民标志，优先按证件类型映射，其次按仓库居民标志映射，最后映射不到的默认居民 （境内）
  *   21   20230301  于敬艺   修改无还本续贷的口径，对公业务的添加判断
  *   22   20230306  于敬艺   修改统计担保方式对公部分码值加工,修改专精特新中小企业标志、专精特新小巨人企业标志
  *   23   20230320  HYF      修改单户授信金额逻辑，与授信基表保持一致
  *   24   20230522  HYF      修改剔除同业法人透支
  *   25   20230522  liuyu    修改 其他个人非农户标识字段，该字段中农户标志判断用ECIF农户标志
  *   26   20230530  YJY      修改是否企业（人行）标识，经与黄娅娅确认，剔除写死的客户号
  *   27   20230608  liuyu    修改网商贷年化利息收益加工逻辑
  *        网商贷利息收益计算标准为：
  *      1保证业务：固定收益5.8%，即放款金额*5.8%；
  *      2信用业务：分段计算
  *      （1）放款日期在2023年4月30日（含）之前的，单笔业务利息收益率为65%，即放款金额*执行利率*65%；
  *      （2）放款日期在2023年4月31日（含）之后的，单笔业务利息收益率为72%，即放款金额*执行利率*72%；
  *  28  20230627   HYF      修改贷款投向境内外标识逻辑，非境外的默认为境内，将未知部分也归到境内
  *  29  20230628   HYF      新增交易对手客户号，G19专属投向行业
  *  30  20230629   HYF      修改贴现部分逻辑，按业务口径当期日减到期日并且余额不为0算逾期
  *  31  20230630   HYF      修改是否投向文化产业大类 CUL_PROPERTY_FLG 零售部分逻辑
  *  32  20230718   yjy      修改展期标识口径，经张家伟确认花呗这个产品应该是不算展期的
  *  33  20230807   HYF      修改二级福费廷贷款投向，客户所属行业，企业规模取穿透后投向
  *  34  20230809   LWB      修改科创企业标志的口径，由之前的信贷合同更改成ecif系统出数
  *  35  20230816   lwb      新增放款时间20230601之后的部分产品为银税合作 modify by lwb
  *  36  20230822   lwb      修改对公数字核心产业的逻辑
  *  37  20230908   HYF      修改高技术产业（制造业）分类的逻辑
  *  38  20230913   HYF      针对恒兴和粤海产品其他个人非农户调整逻辑，非个工商户及小微企业主且非农户
  *  39  20230914   HYF      按业务要求修改银税合作口径，新增税兴贷、税兴贷（网贷）以及5笔经营类推荐渠道贷款
  *  40  20230921   HYF      修改零售部分是否投向文化产业大类，从合同表取标志
  *  41  20231110   HYF      修改逾期本金余额，贴现部分逾期按整笔报送
  *  42  20231117   HYF      新增标准产品名称
  *  43  20231121   HYF      修改对公客户类型、企业规模、是否企业（银监）转贴现部分逻辑
  *  44  20231207   HYF      新增是否玩具业等7个字段
  *  45  20231212   HYF      贷款投向行业逻辑优化，国标的投向系统出数，非国标才需要补录
  *  46  20231227   HYF      修改统计担保方式，零售的子担保方式码值与主担保方式码值录入是同一套，逻辑需调整
  *  47  20240103   HYF      新增重组贷款标志、重组贷款类型代码、重组贷款类型名称
  *  48  20240103   LWB      新增放款时涉农标志和放款时经营性客户类型字段
  *  49  20240123   LWB      修改个人贷款（含联合网贷）客户所属行业的逻辑，改成与报表集市一致
  *  50  20240124   HYF      修改居民标志，新增1123-新版外国人永久居留身份证,
  *                          投向数字经济核心产业中类新增码值05 数字化效率提升业
  *  51  20240131   HYF      修改联合网贷放款日期，不做特殊处理
  *  52  20240206   HYF      修改居民标志，买入二级福费廷不放非居民
  *  53  20240206   YJY      新增是否技术改造项目贷款
  *  54  20240219   lwb      修改是否反担保的出数逻辑
  *  55  20240220   YJY      调整”专精特新客户标志”从补录表出；
  *                          新增”是否监管名单中的专精特新中小企业”,"是否养老产业"
  *  56  20240221   YJY      新增”行政区划代码”，”城市规模”
  *  57  20240222   YJY      新增"额度合同编号","额度合同金额"
  *  58  20240226   YJY      新增"是否投向政府和社会资本合作（PPP）项目","是否新机制发放贷款"
  *  59  20240306   lwb      1012880707客户号默认为非农户 （放款时农户标识），网商贷年化收益字段按新规则计算
  *  60  20240313   YJY      调整”专精特新客户标志”，“专精特新小巨人企业标志”，“高新技术企业标志”，“科技型企业标志”从对公客户信息表出；
  *  61  20240320   HYF      修改其他个人非农户标识客户性质以ECIF为准
  *  62  20240415   HYF      修改贷款投向标志，买入二级福费廷默认为Y-境内
  *  63  20240416   LWB      新增展期未到期字段
  *  64  20240426   LWB      1201235888客户号默认20240331之前的数据为非农户
  *  65  20240506   HYF      新增S63_贴现垫款过路垫款标志,按业务严希婧口径：用于S6301/S6303报送当年累放时剔除该部分数据
  *  66  20240513   LWB      新增是否因资金链断裂导致的逾期未交付项目
  *  67  20240522   HYF      新增种业振兴贷款标志、县城区贷款标志
  *  68  20240523   HYF      修改养老产业标志
  *  69  20240529   HYF      修改工业转型升级标志、战略新兴产业类型、知识产权产业类型代码,新增文化及相关产业类型代码
  *  70  20240611   lwb      其他个人非农户标识新增两个产品：饲料e贷-东腾饲料,饲料e贷-澳华集团
  *  71  20240618   HYF      修改数字经济核心产业、 战略性新兴产业标志、战略性新兴产业类型代码
  *  72  20240621   HYF      按业务要求修改银税合作口径，新增201020100053-好企贷、201020100054-好企贷-IPC产品
  *  73  20240726   lwb      修改年化收益逻辑
  *  74  20240729   LWB      新增放款时企业规模字段
  *  75  20240806   HYF      贷款投向境内外标识对0399-买入其他票据不再特殊处理
  *  76  20240809   lwb      新增是否因资金链断裂导致的逾期未交付项目_开发融资，开发融资_贷款字段
  *  77  20240903   lwb      其他个人非农户标识修改农户标志为放款时农户标志
  *  78  20240904   hyf      修改对公客户类型,S63_贴现垫款过路垫款标志逻辑
  *  79  20240906   hyf      按业务要求修改银税合作口径，剔除201020100054-好企贷-IPC产品
  *  80  20240920   hyf      新增贷款实际到期日期
  *  81  20240925   HYF      新增经营客户类型_大集中
  *  82  20241022   HYF      修改是否关系人保证贷款调整为直取信贷
  *  83  20241118   HYF      修改营客户类型_大集中、新增客户名称_网商贷、时点客户类型_人行、放款时客户类型修改纳入11月放款的赎楼贷
  *  84  20241209   HYF      新增对公贷款中个体工商户逻辑
  *  85  20240110   HYF      修改无还本续贷标志取贷款形式为05、新增逾期期限
  *  86  20250214   HYF      新增诉讼费余额
  *  87  20250305   HYF      新增对公互联网贷款-微业贷的逻辑
  *  88  20250310   HYF      新增创新型中小企业标志、国家企业技术中心标志、各类科技名单企业标志、调整科技型中小企业标志,系统外标志,调整系统内转贴
  *  89  20250318   lwb      修改放款时涉农标志，微粒贷业务的客户统一改为非农户
  *  90  20250318   lwb      新增国家技术创新示范企业、制造业单项冠军企业字段
  *  91  20250324   HYF      新增原建档立卡贫困户标志
  *  92  20250331   HYF      调整系统内转贴对公字段逻辑
  *  93  20250402   XZY      S_LOAN后续还有一百多个过程使用，复原表分析语句
  *  94  20250415   HYF      新增借据层企业统一社会信用代码、借据层企业名称
  *  95  20250506   HYF      调整高技术产业（制造业）分类，对公部分从补录表出数
  *  96  20250514   HYF      新增放款机构号将891转出的机构号固定，方便报表累放指标出数，新增退役军人标志，无营业执照负责人标志
  *  97  20250522   HYF      新增微业贷为关系人保证贷款
  *  98  20250704   HYF      其他个人非农户标识补充字节小微贷取数口径同自营贷款保持一致
  *  99  20250715   HYF      调整CBRC绿色贷款标志、PBOC绿色贷款标志，系统内转贴也需纳入统计
  *  100 20250801   HYF      修改养老产业标志字段逻辑，信贷字段由原来标志调整为码值
  *  101 20250902   HYF      修改贷款投向行业，直取信贷不再取补录,新增高技术服务业标志、养老产业代码
  *  102 20250911   HYF      修改放款时农户标志逻辑，202020200001-字节小微贷，202010200009-字节消费贷，新增原借据号存系统内转贴穿透贴现借据号
  *  103 20251113   HYF      修改是否文化产业标识，联合网贷部分合同没有标识不取，不再按行业投向映射,养老产业零售部分取合同层,深圳分行放款时农户默认为否
  *  104 20251119   HYF      其他个人非农户标识补充201020100064-好企贷（恒兴）
  *  105 20251124   HYF      新增本行出资比例，合作机构出资比例,修改期限
  *  106 20251219   HYF      修改放款时农户标志逻辑，202020200001-字节小微贷，202010200009-字节消费贷取消默认非农户
  *  107 20260121   HYF      修改战略新兴逻辑，零售部分先按行业投向映射，再取信贷合同标签
  *  108 20260129   HYF      新增放款时控股类型
  *  109 20260319   HYF      新增并购贷款类型、是否境外并购贷款、是否退役军人创办企业、放款月企业规模、放款月控股类型
  *  110 20260320   HYF      客户所属行业中优先取经营实体信息的所属行业补充增加大中型企业主过滤
  *  111 20260330   HYF      调整重组标识
  ********************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;              --处理步骤
  V_STEP_DESC VARCHAR2(1000);             --处理步骤描述
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLCOUNT  INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  V_MONTH_START_DATE DATE;               --系统时间对应月初日期
  V_TAB_NAME  VARCHAR2(100) := 'S_LOAN'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_LOAN T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN'||' TRUNCATE PARTITION '||'写上分区名'); --分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  /*EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理*/
  /*DELETE FROM RRP_MDL.S_LOAN WHERE DATA_DT = V_P_DATE;
  COMMIT;*/

  DELETE FROM RRP_MDL.ZTXTMP;
  COMMIT;
  INSERT INTO RRP_MDL.ZTXTMP
    WITH TMP_ZTX AS (
  SELECT B.DUBIL_ID ,A.BILL_NUM,A.BILL_SUB_INTRV_ID
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002') --20220924 MW 修改'204010100001' 银行承兑汇票转贴现 ‘204010100002’ 商业承兑汇票转贴现
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.TRAN_DIR_CD = '01' --MODIFY BY MW 20221207  上游码值变化
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03'--筛选记账成功的票据
     AND A.SYS_IN_FLG = '0' --系统内转贴现
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT C.DUBIL_ID ZTXJJ,B.DUBIL_ID TXJJ,A.BILL_NUM,A.BILL_SUB_INTRV_ID,B.DIR_INDUS_CD,B.CONT_ID
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
     AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN TMP_ZTX C
      ON C.BILL_NUM = A.BILL_NUM
     AND C.BILL_SUB_INTRV_ID = A.BILL_SUB_INTRV_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO D --对公贷款账户信息
      ON D.DUBIL_NUM = B.DUBIL_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO E --贷款合同信息
      ON E.CONT_ID = B.CONT_ID
     AND E.DATA_DT = V_P_DATE
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03' --03 记账完成
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '贷款业务整合表--普通贷款逻辑处理';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.S_LOAN NOLOGGING
    (DATA_DT                             --001 数据日期
    ,LGL_REP_ID                          --002 法人编号
    ,CONT_ID                             --003 合同编号
    ,SUBJ_ID                             --004 科目编号
    ,RCPT_ID                             --005 借据编号
    ,LOAN_BIZ_TYP                        --006 贷款业务类型
    ,LOAN_BIZ_NM                         --007 贷款业务名称
    ,CUST_ID                             --008 客户编号
    ,CUR                                 --009 币种
    ,RCPT_STAT                           --010 借据状态
    ,ORG_ID                              --011 机构编号
    ,LOAN_ACT_DSTR_DT                    --012 贷款实际发放日期
    ,LOAN_AMT                            --013 放款金额
    ,LOAN_ORIG_EXP_DT                    --014 贷款原始到期日期
    ,LVL5_CL                             --015 五级分类
    ,LOAN_TERM                           --016 贷款期限
    ,LOAN_DIR_IDY                        --017 贷款投向行业
    ,BIO_LOAN_FLG                        --018 境内外贷款标志
    ,LOAN_BAL                            --019 贷款余额
    ,INT_ADJ                             --020 利息调整
    ,FAIR_VAL_CHG                        --021 公允价值变动
    ,EXTN_FLG                            --022 展期标志
    ,RCMB_LOAN_FLG                       --023 重组贷款标志
    ,OVD_PRIN_BAL                        --024 逾期本金余额
    ,OVD_DAYS                            --025 逾期天数
    ,IDY_TRNST_UPG_FLG                   --026 工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --027 战略新兴产业类型
    ,RL_EST_LOAN_FLG                     --028 房地产贷款标志
    ,AGR_REL_LOAN_FLG                    --029 涉农贷款标志
    ,SPCL_LOAN_FLG                       --030 专项贷款标志
    ,RATE_TYP                            --031 利率类型
    ,ACT_RATE                            --032 实际利率
    ,BASE_RATE                           --033 基准利率
    ,OV_SEA_MRG_LOAN_FLG                 --034 境外并购贷款标志
    ,CBRC_FLG                            --035 CBRC标志
    ,PBOC_FLG                            --036 PBOC标志
    ,GUA_MODE                            --037 担保方式
    ,SYN_LOAN_FLG                        --038 银团贷款标志
    ,DISC_INT_LOAN_FLG                   --039 贴息贷款标志
    ,ENT_GUA_LOAN_TYP                    --040 创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG               --041 校园消费贷款标志
    ,BANK_TAX_COOP_LOAN_FLG              --042 银税合作贷款标志
    ,NON_REPY_PRIN_RENEW_FLG             --043 无还本续贷标志
    ,PRO_IMPT                            --044 减值准备
    ,CUST_LRG_CL                         --045 客户大类
    ,CORP_CUST_TYP                       --046 对公客户类型
    ,ENT_CLOSE_FLG                       --047 企业关停标志
    ,RSDNT_FLG                           --048 居民标志
    ,FIN_ORG_TYP                         --049 金融机构类型
    ,CUST_BLNG_IDY                       --050 客户所属行业
    ,ENT_SCALE                           --051 企业规模
    ,ENT_HLDG_TYP                        --052 企业控股类型
    ,SGL_CRDT_AMT                        --053 单户授信金额
    ,OPR_CUST_TYP                        --054 经营性客户类型
    ,TECH_MID_SML_ENT_FLG                --055 科技型中小企业标志
    ,ENT_GUA_SML_MICRO_ENT_FLG           --056 创业担保小微企业标志
    ,DISABLED_FLG                        --057 残疾人标志
    ,LOW_INCM_FLG                        --058 低保户标志
    ,HIGH_TECH_IDY_MFG_CL                --059 高技术产业（制造业）分类
    ,DSR                                 --060 DSR
    ,REV_LOAN_FLG                        --061 循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --062 关系人保证贷款标志
    ,REPY_MODE                           --063 还款方式
    ,HIGH_TECH_IDY                       --064 高技术产业
    ,DIGI_ECON_CORE_IDY                  --065 数字经济核心产业
    ,IP_CONC_IDY                         --066 是否投向知识产权密集型产业
    ,AGE                                 --067 借款人年龄
    ,PRCN_CUST_FLG                       --068 是否专精特新中小企业
    ,BEAR_OR_RED_AMT                     --069 承担或减免的信贷费用金额
    ,PRCN_LG_CUST_FLG                    --070 专精特新小巨人客户标志
    ,HIGH_TECH_ENT_FLG                   --071 高新技术企业标志
    ,TECH_ENT_FLG                        --072 科技型企业标志
    ,TECH_INNO_ENT_FLG                   --073 科创企业标志
    ,GENDER                              --074 借款人性别
    ,IND_OPR_LOAN_FLG                    --075 个人经营性贷款标志
    ,FST_LOAN_FLG                        --076 首贷户贷款标志
    ,PRC_BASE_TYP                        --077 定价基准类型
    ,PBOC_GRN_LOAN_FLG                   --078 PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --079 CBRC绿色贷款标志
    ,ACURT_POV_ALLE_LOAN_FLG             --080 精准扶贫贷款标志
    ,MICROFIN_CO_FLG                     --081 小额贷款公司标志
    ,FIN_GUA_ORG_LOAN_FLG                --082 融资担保机构担保贷款标志
    ,GOV_FIN_GUA_LOAN_FLG                --083 政府性融资担保机构担保贷款标志
    ,CNTY_DMN_RGN_FLG                    --084 县域地区标志
    ,ALDY_OFF_POV_RGN_FLG                --085 已脱贫地区标志
    ,POV_ALLE_CNTY_FLG                   --086 重点帮扶县标志
    ,BTH_COOR_DEV_FLG                    --087 京津冀协同发展地区标志
    ,YEB_FLG                             --088 长江经济带地区标志
    ,GBA_FLG                             --089 粤港澳大湾区标志
    ,YRD_AREA_FLG                        --090 长三角区域一体化地区标志
    ,FTA_FLG                             --091 自由贸易区标志
    ,LOAN_DIR_FTA_TYP                    --092 贷款投向自贸区类型
    ,BILL_TYP                            --093 汇票类型
    ,DEPT_LINE                           --094 部门条线
    ,DATA_SRC                            --095 数据来源
    ,CURR_DSTR_AMT                       --096 本期发放金额
    ,NORM_RETRV_AMT                      --097 正常回收金额
    ,ADV_REPY_AMT                        --098 提前还款金额
    ,FARM_FLG                            --099 农户标志
    ,NET_LOAN_FLG                        --100 互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --101 网贷产品类别
    ,COOP_AGRT_ID                        --102 合作协议编号
    ,LOAN_FLG                            --103 贷款种类标识
    ,GXH_PAY_TYPE                        --104 还款方式
    ,GXH_PAY_FREQ                        --105 还款频率
    ,STD_PROD_ID                         --106 标准产品编号
    ,DSBR_MODE                           --107 放款方式
    ,LOAN_DIR_BIO_FLG                    --108 贷款投向境内外标识
    ,ASSET_TRAN_DT                       --109 资产转让日期
    ,OVD_INT_BAL                         --110 逾期利息金额
    ,DISTR_SGL_CRDT_AMT                  --111 发放时单户授信额度
    ,LP_ORG_CUST_ID                      --112 法人机构客户编号
    ,LOAN_NET_VAL                        --113 贷款净值
    ,ORIG_TERM_CODE                      --114 原始期限类型
    ,SUB_GUA_MODE                        --115 子担保方式
    ,LOAN_USEAGE                         --116 贷款用途
    ,PBOC_CUST_CL                        --117 PBOC客户分类
    ,IS_PBOC_ENT                         --118 是否企业（人行）
    ,CBRC_CUST_CL                        --119 CBRC客户分类
    ,IS_CBRC_ENT                         --120 是否企业（银监）
    ,INCOME_ANNUAL                       --121 年化收益
    ,BEAR_OR_RED_TYPE                    --122 本行承担/减免费用类別
    ,HIGH_TECH_FLG                       --123 是否投向高技术产业
    ,INTEL_PROP_FLG                      --124 知识产权产业类型代码
    ,CUL_PROPERTY_FLG                    --125 是否投向文化产业大类
    ,REV_GUAR_FLG                        --126 是否反担保
    ,FIN_SUP_WAY_TYPE                    --127 贷款财政扶持方式
    ,LEAD_AGRI_FLG                       --128 是否农业产业化龙头企业
    ,DELINE_FLG                          --129 是否延期
    ,FIN_SUB_COR_FLG                     --130 是否为理财子公司产品
    ,OPR_CRDT_TOT_AMT                    --131 经营授信总额
    ,CON_CRDT_TOT_AMT                    --132 消费授信总额
    ,DSBR_FARM_FLG                       --133 放款时农户标志
    ,OPER_ORG_ID                         --134 经办机构编号
    ,STRATE_NEW_INDUS_FLG                --135 战略性新兴产业标志
    ,STRATE_NEW_INDUS_TYPE_CD            --136 战略性新兴产业类型代码
    ,TJDBFS                              --137 统计担保方式
    ,QTGRFNH                             --138 其他个人非农户标识
    ,CNTPTY_ID                           --139 交易对手编号
    ,G19_DIR_IDY                         --140 G19专属投向行业
    ,LOAN_TYPE_CD                        --141 借据类型代码
    ,STD_PROD_NM                         --142 标准产品名称
    ,SFWJY                               --143 是否玩具业
    ,WJHYMC                              --144 玩具业行业名称
    ,SFZFZDXM                            --145 是否政府重点项目
    ,SFSQQY                              --146 是否涉侨企业
    ,GYLRZQY                             --147 供应链融资企业
    ,SFTXHSFDCY                          --148 是否投向海上风电产业
    ,SFTXXXCNCY                          --149 是否投向新型储能产业
    ,REGROUP_LOAN_FLG                    --150 重组贷款标志
    ,REGROUP_LOAN_TYPE_CD                --151 重组贷款类型代码
    ,REGROUP_LOAN_TYPE_NAME              --152 重组贷款类型名称
    ,FKSSNBZ                             --153 放款时涉农标志
    ,FKSKHLX                             --154 放款时客户类型
    ,SFJSGZXMDK                          --155 是否技术改造项目贷款
    ,SFJGMDZDZJTXZXQY                    --156 是否监管名单中的专精特新中小企业
    ,SFYLCY                              --157 是否养老产业
    ,REGD_LAND_AREA_CD                   --158 行政区划代码
    ,CITY_SIZE                           --159 城市规模
    ,LMT_CONT_ID                         --160 额度合同编号
    ,LMT_CONT_AMT                        --161 额度合同金额
    ,SFTXZFHSHZBHZ_PPP_XM                --162 是否投向政府和社会资本合作（PPP）项目
    ,SFXJZFFDK                           --163 是否新机制发放贷款
    ,RENEW_FLG_WDQ                       --164 展期未到期标志 --add by lwb 20240408
    ,S63_CSH_FLG                         --165 S63_贴现垫款过路垫款标志
    ,SFYZLLDLYQWJFXM                     --166 是否因资金链断裂导致的逾期未交付项目
    ,SEED_LOAN_FLG                       --167 种业振兴贷款标志
    ,COUNTY_LOAN_FLG                     --168 县城区贷款标志
    ,CUL_AND_RELA_PPTY_TYPE_CD           --169 文化及相关产业类型代码
    ,FKSQYGM                             --170 放款时企业规模
    ,SFYZLLDLYQWJFXMKFRZ                 --171 是否因资金链断裂导致的逾期未交付项目_开发融资
    ,SFYZLLDLYQWJFXMKFRZDK               --172 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
    ,LOAN_ACT_EXP_DT                     --173 贷款实际到期日期
    ,OPR_CUST_TYP_DJZ                    --174 经营客户类型_大集中
    ,CUST_NM_WSD                         --175 客户名称_网商贷
    ,OPR_CUST_TYP_WSD_RH                 --176 时点客户类型_人行
    ,OVD_LOAN_TERM                       --177 逾期期限
    ,SUIT_FEE_BAL                        --178 诉讼费余额
    ,INOVT_MED_SIDE_ENTER_FLG            --179 创新型中小企业标志 ADD BY HYF 20250310
    ,CTY_CORP_TECH_CENTER_FLG            --180 国家企业技术中心标志 ADD BY HYF 20250310
    ,EACH_CLASS_SCEN_TECH_LIST_CORP_FLG  --181 各类科技名单企业标志 ADD BY HYF 20250310
    ,SYS_IN_FLG                          --182 系统外标志 ADD BY HYF 20250310
    ,CTY_TECH_INOVT_CORP_FLG             --183 国家技术创新示范企业标志 ADD BY lwb 20250318
    ,ITEM_CORP_FLG                       --184 制造业单项冠军企业标志 ADD BY lwb 20250318
    ,YJDLKPKH                            --185 原建档立卡贫困户标志 ADD BY HYF 20250324
    ,CORP_CERT_NO                        --186 借据层企业统一社会信用代码 ADD BY HYF 20250415
    ,CORP_NAME                           --187 借据层企业名称 ADD BY HYF 20250415
    ,OLD_CONT_ID                         --188 原合同号 ADD BY HYF 20250415
    ,FK_ORG_ID                           --189 累放层机构号 ADD BY HYF 20250514
    ,EX_SERVSM_FLG                       --190 退役军人标志 ADD BY HYF 20250514
    ,NO_BUSLICS_PRC_FLG                  --191 无营业执照负责人标志 ADD BY HYF 20250514
    ,HIGH_TECH_IDY_SER_FLG               --192 高技术服务业标志 ADD BY HYF 20250902
    ,YLCYDM                              --193 养老产业代码 ADD BY HYF 20250902
    ,OLD_RCPT_ID                         --194 原借据号 ADD BY HYF 20250911
    ,FND_PCT                             --195 本行出资比例 ADD BY HYF 20251124
    ,FND_PCT_HZF                         --196 合作机构出资比例 ADD BY HYF 20251124
    ,FKSKGLX                             --197 放款时控股类型 ADD BY HYF 20260129
    ,BGDKLX                              --198 并购贷款类型 ADD BY HYF 20260319
    ,SFTYJRCBQY                          --199 是否退役军人创办企业 ADD BY HYF 20260319
    ,FKYQYGM                             --200 放款月企业规模 ADD BY HYF 20260319
    ,FKYKGLX                             --201 放款月控股类型 ADD BY HYF 20260319
     )
  WITH CMM_CORP_LOAN_REPAY_DTL AS (
    SELECT /*+ materialize PARALLEL(4)*/ DUBIL_ID
          ,SUM(CURRT_REPAY_PRIC-CURR_NOMAL_PRIC_BAL) CURR_NOMAL_PRIC_BAL
          ,SUM(CURRT_ADV_REPAY_PRIC) CURRT_ADV_REPAY_PRIC
     FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_DTL
    WHERE ETL_DT >= V_MONTH_START_DATE
      AND ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY DUBIL_ID),
   TMP1 AS (
   SELECT /*+ materialize*/NVL(T1.DISCNT_CUST_ID,'-') AS CUST_ID,SUM(T1.LOAN_AMT) AS AMT --放款金额之和
     FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T1
     LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO T7  --授信额度表
       ON T7.CUST_ID = NVL(T1.DISCNT_CUST_ID,'-')
      AND T7.DATA_DT = V_P_DATE
    WHERE SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) = '0302' --买断式转贴现
      AND T1.DATA_DT = V_P_DATE
      AND NVL(T1.DISCNT_CUST_ID,'-') <> '-'
      AND (CASE WHEN SUBSTR(T1.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                ELSE NVL(T1.LOAN_BAL,0) + NVL(T1.FAIR_VAL_CHG,0) - NVL(T1.INT_ADJ,0)
            END) <> 0 --取余额不为0
      AND (NVL(T7.CRDT_TOTAL_LMT, 0) = 0 OR T7.CUST_ID IS NULL) --取当期没有授信直贴人
    GROUP BY NVL(T1.DISCNT_CUST_ID,'-')),
    --加工贴现逾期天数
    TMP2 AS (
  SELECT /*+MATERIALIZE*/A.RCPT_ID  AS RCPT_ID,
         CASE WHEN A.DATA_SRC = '票据贴现'
                   AND TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') < TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND (NVL(A.LOAN_BAL,0)+NVL(A.FAIR_VAL_CHG, 0)-NVL(A.INT_ADJ,0)) <> 0
              THEN TO_DATE(V_P_DATE,'YYYYMMDD') - TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD')
              ELSE 0
          END AS OVD_DAYS
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A
   WHERE A.DATA_SRC = '票据贴现'
     AND A.DATA_DT = V_P_DATE)
  SELECT /*+ USE_HASH(A B C CC CCC D C1 E F)  PARALLEL(4)*/
         A.DATA_DT                              AS DATA_DT                             --001 数据日期
        ,A.LGL_REP_ID                           AS LGL_REP_ID                          --002 法人编号
        ,A.CONT_ID                              AS CONT_ID                             --003 合同编号
        ,A.SUBJ_ID                              AS SUBJ_ID                             --004 科目编号
        ,A.RCPT_ID                              AS RCPT_ID                             --005 借据编号
        ,CASE WHEN A.LOAN_BIZ_TYP LIKE '01%' AND A.LOAN_USEAGE LIKE '%耐用消费品%' THEN '010303'
              WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '010299' --ADD BY 20241209
              WHEN A.DATA_SRC = '票据转贴现' AND A.SYS_IN_FLG = '0' AND A.LOAN_STD_PROD_ID = '204010100001' THEN '030101' --ADD BY 20250310
              WHEN A.DATA_SRC = '票据转贴现' AND A.SYS_IN_FLG = '0' AND A.LOAN_STD_PROD_ID = '204010100002' THEN '030102' --ADD BY 20250310
              ELSE A.LOAN_BIZ_TYP
          END                                   AS LOAN_BIZ_TYP                        --006 贷款业务类型
        ,A.LOAN_BIZ_NM                          AS LOAN_BIZ_NM                         --007 贷款业务名称
        ,CASE WHEN A.DATA_SRC = '票据转贴现' THEN NVL(A.DISCNT_CUST_ID,'-') --转贴现业务直贴人
              --由于客户号非空原则，如果直贴人客户号取不到取直贴人名称,M层已加工
              WHEN A.LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN A.LC_BENEFC
              ELSE A.CUST_ID
          END                                   AS CUST_ID                             --008 客户编号
        ,A.CUR                                  AS CUR                                 --009 币种
        ,A.RCPT_STAT                            AS RCPT_STAT                           --010 借据状态
        ,A.ORG_ID                               AS ORG_ID                              --011 机构编号
        ,A.LOAN_ACT_DSTR_DT                     AS LOAN_ACT_DSTR_DT                    --012 贷款实际发放日期
        ,CASE WHEN A.INTNAL_CARR_FLG = '1' AND SUBSTR(A.ORG_ID,1,3) = '897' THEN 0  --剔除内部结转标志为是，账务机构为897的放款金额（默认取零）
              ELSE A.LOAN_AMT
          END                                   AS LOAN_AMT                            --013 放款金额
        ,A.LOAN_ORIG_EXP_DT                     AS LOAN_ORIG_EXP_DT                    --014 贷款原始到期日期
        ,A.LVL5_CL                              AS LVL5_CL                             --015 五级分类
/*        ,CASE WHEN A.DATA_SRC = '零售贷款'
              THEN (CASE WHEN A.RCPT_ID IN ('HT11012018120500005J001','HT11012018120500006J001'
                                           ,'HT11012018120600037J001','HT11012018120700005J001'
                                           ,'HT11012018120700019J001'
                                           ,'HT11012018120700052J001','HT11012018121200032J001'
                                           ,'HT11012018121300019J001','HT11012018121300063J001'
                                           ,'HT11012018121400010J001')
                         THEN 'S'  --经业务确认，这11笔借据为短期，写定期限类型 'HT11012018120700006J001' 剔除默认为短期，业务确认这笔为中长期
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>60 THEN 'L'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>36 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>24 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>12 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>6 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>3 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>=0 THEN 'S'
                    END)
              WHEN A.DATA_SRC IN ('联合网贷','对公联合网贷')
              THEN (CASE WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >60 THEN 'L'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >36 THEN 'M'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >24 THEN 'M'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >=13 THEN 'M'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >6 THEN 'S'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >3 THEN 'S'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >=0 THEN 'S'
                    END)
              WHEN A.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
              THEN (CASE WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>60 THEN 'L'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>36 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>24 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>12 THEN 'M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>6 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>3 THEN 'S'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>=0 THEN 'S'
                    END)
          END                                   AS LOAN_TERM */                          --016 贷款期限
        ,CASE WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>60 THEN 'L'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>36 THEN 'M'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>24 THEN 'M'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>12 THEN 'M'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>6 THEN 'S'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>3 THEN 'S'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>=0 THEN 'S'
         END                                    AS LOAN_TERM                           --016 贷款期限
        ,CASE WHEN ZTXTMP.ZTXJJ IS NOT NULL THEN ZTXTMP.DIR_INDUS_CD  --ADD BY 20250331
              ELSE A.LOAN_DIR_IDY
          END                                   AS LOAN_DIR_IDY                        --017 贷款投向行业 20250902
        ,A.BIO_LOAN_FLG                         AS BIO_LOAN_FLG                        --018 境内外贷款标志
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) IN ('810601','710701') THEN 0
              ELSE A.LOAN_BAL
          END                                   AS LOAN_BAL                            --019 贷款余额
        ,A.INT_ADJ                              AS INT_ADJ                             --020 利息调整
        ,A.FAIR_VAL_CHG                         AS FAIR_VAL_CHG                        --021 公允价值变动
        ,CASE WHEN NVL(A.EXTN_CNT,0) > 0 AND A.LOAN_STD_PROD_ID <> '202010100004' --moddify by yjy in 20230718 经张家伟确认花呗这个产品应该是不算展期的
              THEN 'Y'
              ELSE 'N'
          END                                   AS EXTN_FLG                            --022 展期标志
        ,CASE WHEN A.DATA_SRC = '对公信贷' AND A.LOAN_FRM IN ('05','9906') AND A.RCMM_LOAN_FLG = 'Y' THEN 'Y'
              WHEN A.DATA_SRC = '对公信贷' AND A.LOAN_FRM = '04' THEN 'Y' 
              WHEN A.RCMM_LOAN_FLG = 'Y' THEN A.RCMM_LOAN_FLG
         ELSE 'N' 
         END                                    AS RCMB_LOAN_FLG                       --023 重组贷款标志
        ,CASE WHEN A.DATA_SRC = '票据贴现'
                   AND TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') < TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND (NVL(A.LOAN_BAL,0)+NVL(A.FAIR_VAL_CHG, 0)-NVL(A.INT_ADJ,0)) <> 0
              THEN NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
              ELSE NVL(A.OVD_PRIN_BAL,0)
          END                                   AS OVD_PRIN_BAL                        --024 逾期本金余额
        ,CASE WHEN A.DATA_SRC = '票据贴现'
                   AND TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') < TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND (NVL(A.LOAN_BAL,0)+NVL(A.FAIR_VAL_CHG, 0)-NVL(A.INT_ADJ,0)) <> 0
              THEN TO_DATE(V_P_DATE,'YYYYMMDD') - TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD')
              ELSE A.OVD_DAYS
          END                                   AS OVD_DAYS                            --025 逾期天数
        /*,A.IDY_TRNST_UPG_FLG*/
         /*CASE WHEN A.LOAN_BIZ_TYP NOT LIKE '01%'
              THEN M2.SFGYQYJSGZSJDK
            END*/
        ,DECODE(B.INDU_CORP_TECH_REM_UGD_FLG,'1','Y','N')                           AS IDY_TRNST_UPG_FLG                   --026 工业转型升级标志
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') THEN M2.TXZLXXXCYML
              ELSE CASE WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '1' THEN 'C' --节能环保 
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '2' THEN 'D' --新一代信息技术
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '3' THEN 'E' --生物医药
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '4' THEN 'F' --高端装备制造
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '5' THEN 'G' --新能源
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '6' THEN 'H' --新材料
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '7' THEN 'I' --新能源汽车
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '8' THEN 'J' --数字创意产业
                        WHEN /*EE.INDUSTRY*/ EE.INDUSTRY_CD = '9' THEN 'K' --相关服务业    --UPDATE BY YJY 20260403 
              ELSE CASE WHEN B.STRATE_NEW_INDUS_TYPE_CD = '7' THEN 'C' --节能环保
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '1' THEN 'D' --新一代信息技术
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '4' THEN 'E' --生物医药
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '2' THEN 'F' --高端装备制造
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '6' THEN 'G' --新能源
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '3' THEN 'H' --新材料
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '5' THEN 'I' --新能源汽车
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '8' THEN 'J' --数字创意产业
                        WHEN B.STRATE_NEW_INDUS_TYPE_CD = '9' THEN 'K' --相关服务业
                        ELSE 'NA' END
              END
          END                                   AS STRTG_EMER_IDY_TYP                  --027 战略新兴产业类型
        ,A.RL_EST_LOAN_FLG                      AS RL_EST_LOAN_FLG                     --028 房地产贷款标志
        ,A.AGR_REL_LOAN_FLG                     AS AGR_REL_LOAN_FLG                    --029 涉农贷款标志
        ,A.SPCL_LOAN_FLG                        AS SPCL_LOAN_FLG                       --030 专项贷款标志
        ,A.RATE_TYP                             AS RATE_TYP                            --031 利率类型
        ,A.EXEC_RATE                            AS ACT_RATE                            --032 实际利率
        ,A.BASE_RATE                            AS BASE_RATE                           --033 基准利率
        ,A.SFJWBGDK                             AS OV_SEA_MRG_LOAN_FLG                 --034 境外并购贷款标志 MOD BY 20260320
        ,'Y'                                    AS CBRC_FLG                            --035 CBRC标志
        ,'Y'                                    AS PBOC_FLG                            --036 PBOC标志
        ,--A.GUA_MODE
         B.MAIN_GUA_MODE                        AS GUA_MODE                            --037 担保方式
        ,A.SYN_LOAN_FLG                         AS SYN_LOAN_FLG                        --038 银团贷款标志
        ,CASE WHEN A.LOAN_FINC_SPT_MODE IS NOT NULL THEN 'Y'
              ELSE 'N'
         END                                    AS DISC_INT_LOAN_FLG                   --039 贴息贷款标志
        ,A.ENT_GUA_LOAN_TYP                     AS ENT_GUA_LOAN_TYP                    --040 创业担保贷款类型
        ,A.CAMPUS_CNSMP_LOAN_FLG                AS CAMPUS_CNSMP_LOAN_FLG               --041 校园消费贷款标志
        ,CASE WHEN A.LOAN_ACT_DSTR_DT >= '20230601' AND A.LOAN_STD_PROD_ID IN ('201020100017','201020100006','201010300008',
                   '201020100021','201010300014','201020100019','201010300013','201020100005','201010300007','201020100020',
                   '201020100009','201020100016','201020100010','201020100044','201020100043','201010300012') --新增放款时间20230601之后的部分产品为银税合作 MODIFY BY LWB
              THEN 'Y'
              WHEN (A.LOAN_STD_PROD_ID IN ('201020100003','201020100012')
                   OR A.RCPT_ID IN ('UPL2017113000000019000','UPL2017122000000053000','UPL2018010800000005000',
                   'UPL2017122200000040000','UPL2017080900000017000'))
              THEN 'Y'
              WHEN A.LOAN_STD_PROD_ID IN ('201020100053')
              THEN 'Y'
              ELSE A.BANK_TAX_COOP_LOAN_FLG
          END                                   AS BANK_TAX_COOP_LOAN_FLG              --042 银税合作贷款标志
        ,CASE --WHEN A.DATA_SRC = '零售贷款' AND B.LOAN_HAPP_TYPE_CD = '0102' THEN 'Y'
              --WHEN A.DATA_SRC = '对公信贷' AND B.LOAN_HAPP_TYPE_CD = '0202' --借新还旧
              WHEN A.LOAN_FRM = '05' AND A.RCMM_LOAN_FLG = 'N' --ADD BY 20260330 补充剔除无还本续贷中属于重组贷款的
              THEN 'Y'
              ELSE 'N'
          END                                   AS NON_REPY_PRIN_RENEW_FLG             --043 无还本续贷标志 --MOD BY 20250110 HYF
        ,A.PRO_IMPT                             AS PRO_IMPT                            --044 减值准备
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '01'--ADD BY 20241209
              WHEN D.CUST_ID IS NOT NULL THEN '01' --对私客户
              WHEN C.CUST_ID IS NOT NULL THEN '02' --对公客户
              --MOD BY LIUYU 20230207 改客户大类逻辑，不按照存款逻辑判断
          END                                   AS CUST_LRG_CL                         --045 客户大类
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '' --ADD BY 20241209
              WHEN A.DATA_SRC = '票据转贴现' THEN 'A01'
              WHEN C.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）')
              THEN 'A01'
              ELSE C.CUST_CL
          END                                   AS CORP_CUST_TYP                       --046 对公客户类型
        /*,C.ENT_CLOSE_FLG                        AS ENT_CLOSE_FLG                       --047 企业关停标志*/
        ,M1.SFGTQY                              AS ENT_CLOSE_FLG                       --047 企业关停标志 --MDF BY XUFEI 221214 从补录表出数
        ,CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,0,4) = '0399' THEN 'Y'
              WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现','对公联合网贷') THEN DECODE(C.RSDNT_FLG,'N','N','Y')
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷') AND D.CRDL_TYP IN ('1010','1011', '1021', '1022', '1025', '1030', '1040', '1122','1123') THEN 'Y' --身份证及临时身份证
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷') AND D.CRDL_TYP IN ('1052', '1070', '1071', '1072', '1073', '1074','1141','1142') THEN 'N'
              WHEN D.RSDNT_FLG = 'N' THEN 'N'
              ELSE 'Y'
          END                                   AS RSDNT_FLG                           --048 居民标志
        ,C.FIN_ORG_TYP                          AS FIN_ORG_TYP                         --049 金融机构类型
        ,CASE WHEN A.LOAN_STD_PROD_ID IN ('202020100001','202020200004')
                   AND (SUBSTR(D.CUST_BLNG_IDY,0,1) IN ('T','S','-') OR D.CUST_BLNG_IDY IS NULL) THEN 'F'
              WHEN ( D.OPR_CUST_TYP IN ('A','B') OR D.CRDT_CUST_TYPE_CD = '04' ) --ADD BY 20260320 补充大型企业主过滤
                   AND LENGTH(DDD.MANG_ENTY_BL_INDUTY_TYPE_CD) > 1
                   AND DDD.MANG_ENTY_BL_INDUTY_TYPE_CD <> '-'
              THEN DDD.MANG_ENTY_BL_INDUTY_TYPE_CD
              ELSE NVL(C.CUST_BLNG_IDY,D.CUST_BLNG_IDY)
          END                                   AS CUST_BLNG_IDY                       --050 客户所属行业
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '' --ADD BY 20241209
              WHEN A.DATA_SRC = '票据转贴现' AND (C.CUST_ID IS NULL OR C.ENT_SCALE = 'Z') THEN 'M'
              ELSE C.ENT_SCALE
          END                                   AS ENT_SCALE                           --051 企业规模,无直贴人客户号默认中型企业M
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '' --ADD BY 20241209
              ELSE C.ENT_HLDG_TYP
          END                                   AS ENT_HLDG_TYP                        --052 企业控股类型
        ,NVL(E.CRDT_TOTAL_LMT_ZT,T10.AMT)       AS SGL_CRDT_AMT                     --053 单户授信金额
        ,CASE WHEN C.CUST_CL = 'E' THEN 'A'
              ELSE NVL(D.OPR_CUST_TYP,'Z')
          END                                   AS OPR_CUST_TYP                        --054 经营性客户类型
        ,C.TECH_MID_SML_ENT_FLG                 AS TECH_MID_SML_ENT_FLG                --055 科技型中小企业标志
        ,C.ENT_GUA_SML_MICRO_ENT_FLG            AS ENT_GUA_SML_MICRO_ENT_FLG           --056 创业担保小微企业标志
        ,D.DISABLED_FLG                         AS DISABLED_FLG                        --057 残疾人标志
        ,D.LOW_INCM_FLG                         AS LOW_INCM_FLG                        --058 低保户标志
        ,CASE WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷') THEN B.HIGH_TECH_PROPERTY_TYPE_CD
              ELSE CODE3.TAR_VALUE_CODE
          END                                   AS HIGH_TECH_IDY_MFG_CL                --059 高技术产业（制造业）分类
        ,CASE WHEN D.FAMILY_YEAR_INCOME IS NULL OR D.FAMILY_YEAR_INCOME = 0 THEN 0
              ELSE ROUND(A.LOAN_BAL * 12 / D.FAMILY_YEAR_INCOME, 4)
          END                                   AS DSR                                 --060 DSR
        ,A.REV_LOAN_FLG                         AS REV_LOAN_FLG                        --061 循环贷贷款标志
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203050100001' THEN 'Y'
              ELSE DECODE(B.RELA_PEOP_GUAR_LOAN_FLG,'1','Y','N')
          END                                   AS REL_PSN_GUA_LOAN_FLG     --062 关系人保证贷款标志
        ,A.REPY_MODE                            AS REPY_MODE                           --063 还款方式
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') THEN M2.SFTXGJSCY --是否投向高技术产业
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷') AND B.HIGH_TECH_PROPERTY_TYPE_CD NOT IN ('08') THEN 'Y'
              WHEN A.DATA_SRC IN ('对公联合网贷') THEN B.HIGH_TECH_PROPERTY_FLG
              ELSE 'N'
          END                                   AS HIGH_TECH_IDY                       --064 高技术产业 MODIFY BY 于敬艺 IN 20230215
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') THEN M2.TXSZJJHXCYDL
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷') THEN B.DIGIT_ECON_CORE_PROPERTY_TYPE_CD
              END                               AS DIGI_ECON_CORE_IDY                  --065 数字经济核心产业 MODIFY BY HYF IN 20250415
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') THEN M2.SFTXZSCQMJXCY --是否投向知识产权密集型产业
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷') AND B.INTEL_PROP_INTE_PROPERTY_TYPE_CD = '1'
              THEN 'Y'
              ELSE 'N'
          END                                   AS IP_CONC_IDY                         --066 是否投向知识产权密集型产业 MODIFY BY 于敬艺 IN 20230215
        ,D.AGE                                  AS AGE                                 --067 借款人年龄
        ,/*C.PRCN_CUST_FLG                        AS PRCN_CUST_FLG */                       --068 专精特新客户标志
         /*B.SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG  AS PRCN_CUST_FLG    */                  --068 专精特新客户标志   MODIFY 于敬艺 in 20230306
         /*M2.SFZJTXZXQY                          AS PRCN_CUST_FLG */            --068 是否专精特新中小企业     MODIFY by  YJY IN 20240220
         C.PRCN_SML_CUST_FLG                    AS PRCN_CUST_FLG              --068 是否专精特新中小企业     MODIFY by  YJY IN 20240313
        ,/*A.BEAR_OR_RED_AMT*/                  ----MDF BY XUFEI 221214 从补录表出数  (仅对公，零售只能直取减免费用补录表)
         NVL(M1.BNLJCDHJMDXDXGFYJE,0)           AS BEAR_OR_RED_AMT                     --069 承担或减免的信贷费用金额
        ,C.PRCN_LG_CUST_FLG                     AS PRCN_LG_CUST_FLG                --070 专精特新小巨人客户标志     MODIFY 于敬艺 in 20230313
         /* B.SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG      AS PRCN_LG_CUST_FLG  */           --070 专精特新小巨人客户标志    MODIFY 于敬艺 in 20230306
        ,C.HIGH_TECH_ENT_FLG                    AS HIGH_TECH_ENT_FLG               --071 高新技术企业标志    --MODIFY 于敬艺 in 20230313
         /*B.HIGH_NEW_TECH_CORP_FLG               AS HIGH_TECH_ENT_FLG    */        --071 高新技术企业标志  --MODIFY 于敬艺 in 20230220
        ,C.TECH_ENT_FLG                         AS TECH_ENT_FLG                        --072 科技型企业标志   --MODIFY 于敬艺 in 20230313
         /*B.SCI_TECH_CORP_FLG                   AS TECH_ENT_FLG  */                     --072 科技型企业标志   --MODIFY 于敬艺 in 20230220
        ,C.TECH_INNO_ENT_FLG                    AS TECH_INNO_ENT_FLG                   --073 科创企业标志
        ,D.GENDER                               AS GENDER                              --074 借款人性别
        ,CASE WHEN A.LOAN_BIZ_TYP LIKE '0102%' --个人经营性贷款
              THEN 'Y'
              ELSE 'N'
          END                                   AS IND_OPR_LOAN_FLG                    --075 个人经营性贷款标志
        ,A.FST_LOAN_FLG                         AS FST_LOAN_FLG                        --076 首贷户贷款标志
        ,A.PRC_BASE_TYP                         AS PRC_BASE_TYP                        --077 定价基准类型
        /*,CASE WHEN ZTXTMP.ZTXJJ IS NOT NULL THEN 'Y'
              ELSE A.PBOC_GRN_LOAN_FLG
          END                                   AS PBOC_GRN_LOAN_FLG                   --078 PBOC绿色贷款标志 MODIFY BY 20250715
        ,CASE WHEN ZTXTMP.ZTXJJ IS NOT NULL THEN 'Y'
              ELSE A.CBRC_GRN_LOAN_FLG
          END                                   AS CBRC_GRN_LOAN_FLG                   --079 CBRC绿色贷款标志 MODIFY BY 20250715*/
        --MOD BY HYF 20250813 --系统内转贴现数据的绿色贷款标志，按照对应贴现借据的绿色贷款标志判断
        ,CASE WHEN ZTX_GREEN.RCPT_ID IS NOT NULL THEN ZTX_GREEN.PBOC_GRN_LOAN_FLG
              WHEN ZTXTMP.ZTXJJ IS NOT NULL THEN 'N'
              ELSE A.PBOC_GRN_LOAN_FLG
          END                                   AS PBOC_GRN_LOAN_FLG                   --078 PBOC绿色贷款标志 MODIFY BY HYF 20250813
        ,CASE WHEN ZTX_GREEN.RCPT_ID IS NOT NULL THEN ZTX_GREEN.CBRC_GRN_LOAN_FLG
              WHEN ZTXTMP.ZTXJJ IS NOT NULL THEN 'N'
              ELSE A.CBRC_GRN_LOAN_FLG
          END                                   AS CBRC_GRN_LOAN_FLG                   --079 CBRC绿色贷款标志 MODIFY BY HYF 20250813
        ,A.ACURT_POV_ALLE_LOAN_FLG              AS ACURT_POV_ALLE_LOAN_FLG             --080 精准扶贫贷款标志
        ,NVL(C.MICROFIN_CO_FLG,'N')             AS MICROFIN_CO_FLG                     --081 小额贷款公司标志
        --A.FIN_GUA_ORG_LOAN_FLG                 AS FIN_GUA_ORG_LOAN_FLG                --082 融资担保机构担保贷款标志
        ,NVL(M3.SFRZDBGSBZ,M4.SFRZDBGSBZ)       AS FIN_GUA_ORG_LOAN_FLG                --082 融资担保机构担保贷款标志
        --,A.GOV_FIN_GUA_LOAN_FLG                 AS GOV_FIN_GUA_LOAN_FLG                --083 政府性融资担保机构担保贷款标志
        ,NVL(M3.SFZFXRZDBGSBZ,M4.SFZFXRZDBGSBZ) AS GOV_FIN_GUA_LOAN_FLG                --083 政府性融资担保机构担保贷款标志
        ,CASE WHEN Z1.CNTY_DMN = 'Y' THEN 'Y'
              WHEN Z1.CNTY_DMN = 'N' AND Z2.CNTY_DMN = 'Y' THEN 'Y'
              WHEN Z1.CNTY_DMN = 'N' AND Z3.CNTY_DMN = 'Y' THEN 'Y'
              ELSE 'N'
          END                                   AS CNTY_DMN_RGN_FLG                    --084 县域地区标志
        ,CASE WHEN Z1.POOR_CNTY = 'Y' THEN 'Y'
              WHEN Z2.POOR_CNTY = 'Y' THEN 'Y'
              WHEN Z3.POOR_CNTY = 'Y' THEN 'Y'
              ELSE 'N'
          END                                   AS ALDY_OFF_POV_RGN_FLG                --085 已脱贫地区标志
        ,CASE WHEN Z1.NATL_REVITAL_CNTY = 'Y' THEN 'Y'
              WHEN Z2.NATL_REVITAL_CNTY = 'Y' THEN 'Y'
              WHEN Z3.NATL_REVITAL_CNTY = 'Y' THEN 'Y'
              ELSE 'N'
          END                                   AS POV_ALLE_CNTY_FLG                   --086 重点帮扶县标志
        ,CASE WHEN Z1.BTH_COOR_DEV_FLG = 'Y' THEN 'Y'
              ELSE 'N'
          END                                   AS BTH_COOR_DEV_FLG                    --087 京津冀协同发展地区标志
        ,CASE WHEN Z1.YEB_FLG = 'Y' THEN 'Y'
              ELSE 'N'
          END                                   AS YEB_FLG                             --088 长江经济带地区标志
        ,CASE WHEN SUBSTR(A.ORG_ID,1,3) IN ('801','803','805','806','807','808','809','810','811') THEN 'Y'
              ELSE 'N'
          END                                   AS GBA_FLG                             --089 粤港澳大湾区标志
        ,CASE WHEN Z1.YRD_AREA_FLG = 'Y' THEN 'Y'
              ELSE 'N'
          END                                   AS YRD_AREA_FLG                        --090 长三角区域一体化地区标志
        ,CASE WHEN SUBSTR(A.ORG_ID,0,5) IN ('80106','80508') THEN 'Y'--80106，80508机构判定其是否属于自贸区
              ELSE 'N'
          END                                   AS FTA_FLG                             --091 自由贸易区标志 自贸区机构：广东自贸试验区南沙支行
        ,A.LOAN_DIR_FTA_TYP                     AS LOAN_DIR_FTA_TYP                    --092 贷款投向自贸区类型
        ,CASE WHEN P.BILL_TYP = 01 AND P.ACPTR_NM LIKE '%财务公司%' THEN '财务公司承兑汇票'
              WHEN P.BILL_TYP = 01 AND P.ACPTR_NM NOT LIKE '%财务公司%' THEN '银行承兑汇票'
              WHEN P.BILL_TYP = 02 THEN '商业承兑汇票'
              ELSE NULL
          END                                   AS BILL_TYP                            --093 汇票类型
        ,A.DEPT_LINE                            AS DEPT_LINE                           --094 部门条线
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '零售贷款' --ADD BY 20241209
              WHEN A.DATA_SRC = '对公联合网贷' THEN '对公信贷'
              WHEN A.DATA_SRC = '票据转贴现' AND A.SYS_IN_FLG = '0' THEN '票据贴现' --ADD BY 20250310
              ELSE A.DATA_SRC
          END                                   AS DATA_SRC                            --095 数据来源
        ,A.LOAN_AMT                             AS CURR_DSTR_AMT                       --096 本期发放金额
        ,F.CURR_NOMAL_PRIC_BAL                  AS NORM_RETRV_AMT                      --097 正常回收金额
        ,F.CURRT_ADV_REPAY_PRIC                 AS ADV_REPY_AMT                        --098 提前还款金额
        ,NVL(D.FARM_FLG,'N')                    AS FARM_FLG                            --099 农户标志
        ,A.NET_LOAN_FLG                         AS NET_LOAN_FLG                        --100 互联网贷款标志
        ,A.NET_LOAN_PROD_TYP                    AS NET_LOAN_PROD_TYP                   --101 网贷产品类别
        ,B.COOP_AGRT_ID                         AS COOP_AGRT_ID                        --102 合作协议编号
        ,A.LOAN_FLG                             AS LOAN_FLG                            --103 贷款种类标识
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '-'--ADD BY 20241209
              ELSE A.GXH_PAY_TYPE
          END                                   AS GXH_PAY_TYPE                        --104 还款方式
        ,CASE WHEN A.DATA_SRC = '联合网贷' THEN DECODE(A.GXH_PAY_FREQ,'03','M','-')
              ELSE A.GXH_PAY_FREQ
          END                                   AS GXH_PAY_FREQ                        --105 还款频率
        ,CASE WHEN A.DATA_SRC = '票据转贴现' AND A.SYS_IN_FLG = '0' AND A.LOAN_STD_PROD_ID = '204010100001' THEN '204010200001' --ADD BY 20250310
              WHEN A.DATA_SRC = '票据转贴现' AND A.SYS_IN_FLG = '0' AND A.LOAN_STD_PROD_ID = '204010100002' THEN '204010200002'
              ELSE A.LOAN_STD_PROD_ID
          END                                   AS STD_PROD_ID                         --106 标准产品编号
        ,A.DSBR_MODE                            AS DSBR_MODE                           --107 放款方式
        ,CASE WHEN A.DATA_SRC IN ('对公信贷') THEN DECODE(A.LOAN_DIR_BIO_FLG,'N','N','Y')
              ELSE 'Y'
          END /*A.LOAN_DIR_BIO_FLG*/            AS LOAN_DIR_BIO_FLG                    --108 贷款投向境内外标识
        ,A.ASSET_TRAN_DT                        AS ASSET_TRAN_DT                       --109 资产转让日期
        ,A.OVD_INT_BAL                          AS OVD_INT_BAL                         --110 逾期利息金额
        ,A.LOAN_CRDT_LMT_TOT                    AS DISTR_SGL_CRDT_AMT                  --111 发放时单户授信额度
        ,C.LP_ORG_CUST_ID                       AS LP_ORG_CUST_ID                      --112 法人机构客户编号
        ,CASE WHEN SUBSTR(A.SUBJ_ID,1,6) IN ('810601','710701') THEN 0
              ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
          END                                   AS LOAN_NET_VAL                        --113 贷款净值
/*        ,CASE WHEN A.DATA_SRC = '零售贷款'
              THEN (CASE WHEN A.RCPT_ID IN ('HT11012018120500005J001','HT11012018120500006J001'
                                           ,'HT11012018120600037J001','HT11012018120700005J001'
                                           ,'HT11012018120700019J001'
                                           ,'HT11012018120700052J001','HT11012018121200032J001'
                                           ,'HT11012018121300019J001','HT11012018121300063J001'
                                           ,'HT11012018121400010J001')
                         THEN '12M'  --经业务确认，这11笔借据为短期，写定期限类型 'HT11012018120700006J001' 剔除默认为短期，业务确认这笔为中长期
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>60 THEN '5YA'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>36 THEN '5Y'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>24 THEN '3Y'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>12 THEN '2Y'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>6 THEN '12M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>3 THEN '6M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>=0 THEN '3M'
                    END)
              WHEN A.DATA_SRC IN ('联合网贷','对公联合网贷')
              THEN (CASE WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >60 THEN '5YA'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >36 THEN '5Y'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >24 THEN '3Y'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >=13 THEN '2Y'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >6 THEN '12M'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >3 THEN '6M'
                         WHEN (TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD') - TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')) / 30 >=0 THEN '3M'
                    END)
              WHEN A.DATA_SRC IN ('对公信贷', '票据贴现', '票据转贴现')
              THEN (CASE WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>60 THEN '5YA'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>36 THEN '5Y'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>24 THEN '3Y'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>12 THEN '2Y'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>6 THEN '12M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>3 THEN '6M'
                         WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>=0 THEN '3M'
                    END)
          END                                   AS ORIG_TERM_CODE                      --114 原始期限类型*/
        ,CASE WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>60 THEN '5YA'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>36 THEN '5Y'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>24 THEN '3Y'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>12 THEN '2Y'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>6 THEN '12M'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>3 THEN '6M'
              WHEN MONTHS_BETWEEN(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'))>=0 THEN '3M'
         END                                    AS ORIG_TERM_CODE                      --114 原始期限类型          
        ,B.SUB_GUA_MODE                         AS SUB_GUA_MODE                        --115 子担保方式
        ,A.LOAN_USEAGE                          AS LOAN_USEAGE                         --116 贷款用途
        ,C.PBOC_CUST_CL                         AS PBOC_CUST_CL                        --117 PBOC客户分类
        ,CASE /*WHEN C.CUST_ID IN ('5000035157','5000035377','5000034464','5000034466','5000043791','5000034465'
                                 ,'5000040647','5000040208','5000000287','5000041837','5000038077','5000018811'
                                 ,'5000033906') --不再改变的客户清单
               AND (NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0))<>0
              THEN 'Y' */  --20221209与风管部方清华确认：报送当期该客户名下有未结清的借据，优先取业务的台账分类，其余按照新口径划分。如果当期该客户已全部结清后又新发放的贷款，直接按照监管新口径划分。
              --UPDATE BY YJY IN 20230530 经与黄娅娅沟通确认，剔除掉写死的客户号
              WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN 'N' --ADD BY 20241209
              WHEN C.PBOC_CUST_CL  = '企业'
              THEN 'Y'
              ELSE 'N'
          END                                   AS IS_PBOC_ENT                          --118 是否企业（人行）
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN '-' --ADD BY 20241209
              ELSE C.CBRC_CUST_CL
          END                                   AS CBRC_CUST_CL                        --119 CBRC客户分类
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN 'N' --ADD BY 20241209
              WHEN A.DATA_SRC = '票据转贴现' THEN 'Y'
              WHEN C.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）')
              THEN 'Y'
              ELSE 'N'
          END                                   AS IS_CBRC_ENT                         --120 是否企业（银监）
        ,CASE WHEN A.EXEC_RATE IS NULL OR A.EXEC_RATE = 0 THEN 0
              ELSE CASE WHEN A.ORG_ID LIKE '898%' AND A.DATA_SRC = '联合网贷' THEN
                        CASE WHEN  A.LOAN_TYPE_CD='15121200' --助贷3.0-直投-信用
                              THEN (A.LOAN_AMT*A.EXEC_RATE/100) * 0.90
                             WHEN   A.LOAN_TYPE_CD='14121210' AND A.LOAN_ACT_DSTR_DT<'20250401'--均衡联营-直投-增信
                              THEN  A.LOAN_AMT*0.05
                             WHEN   A.LOAN_TYPE_CD='14121210' AND A.LOAN_ACT_DSTR_DT>='20250401'--均衡联营-直投-增信
                              THEN  A.LOAN_AMT*0.035
                             WHEN   A.LOAN_TYPE_CD='00121210' AND A.LOAN_ACT_DSTR_DT<='20240425' --债权直转-直投-增信
                              THEN  A.LOAN_AMT*0.045
                             WHEN   A.LOAN_TYPE_CD='00121210' AND A.LOAN_ACT_DSTR_DT>'20240425' --债权直转-直投-增信
                              THEN  A.LOAN_AMT*0.04
                             WHEN   A.LOAN_TYPE_CD='13111210' AND A.LOAN_ACT_DSTR_DT<='20230929' --均衡联营-联合贷款-增信
                              THEN  A.LOAN_AMT*0.058
                             WHEN   A.LOAN_TYPE_CD='13111210' AND A.LOAN_ACT_DSTR_DT>'20230929' --均衡联营-联合贷款-增信
                              THEN  A.LOAN_AMT*0.05
                             WHEN   A.LOAN_TYPE_CD='01111200' AND A.LOAN_ACT_DSTR_DT BETWEEN '20230412' AND '20240429'
                              THEN   (A.LOAN_AMT*A.EXEC_RATE/100) * 0.65  --标准联营-联合贷款-信用 --modify by lwb 20240729
                             WHEN   A.LOAN_TYPE_CD='01111200' AND A.LOAN_ACT_DSTR_DT >'20240429'
                              THEN   (A.LOAN_AMT*A.EXEC_RATE/100) * 0.72  --标准联营-联合贷款-信用
                             WHEN (A.LOAN_ACT_DSTR_DT BETWEEN '20180901' AND '20190831')
                               OR (A.LOAN_ACT_DSTR_DT BETWEEN '20201208' AND '20211124')
                               OR (A.LOAN_ACT_DSTR_DT BETWEEN '20190901' AND '20201207')
                               OR (A.LOAN_ACT_DSTR_DT >'20211125' AND A.LOAN_ACT_DSTR_DT<='20230411')
                                THEN (A.LOAN_AMT*A.EXEC_RATE/100) * 0.65
                                    END
                        ELSE A.LOAN_AMT*A.EXEC_RATE/100 --MODIFY BY LWB 20240726
                   END
          END                                   AS INCOME_ANNUAL                       --121 年化收益
        ,DECODE(M1.BXCDJMFYLB,'01','01'--抵押登记费(承担)
                             ,'02','02'--押品评估费(承担)
                             ,'03','03'--其他信贷相关承担费用(承担)
                             ,'04','04'--客户承担(承担)
                             ,'05','05'--咨询费(减免)
                             ,'06','06'--财务顾问费(减免)
                             ,'07','07'--其他信贷相关减免费用(减免)
                             ,'08','08'--其他表外费用减免(减免)
                             ,'NA')             AS BEAR_OR_RED_TYPE                    --122本行承担/减免费用类別(对公)  --ADD BY XUFEI 221214
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') THEN M2.SFTXGJSCY --是否投向高技术产业
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷') AND B.HIGH_TECH_PROPERTY_TYPE_CD NOT IN ('08') THEN 'Y'
              ELSE 'N'
          END                                   AS HIGH_TECH_FLG                       --123 是否投向高技术产业
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') AND M2.SFTXZSCQMJXCY = 'Y'
              THEN GG.L_CORE
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷')
              THEN B.PROP_PROPERTY_TYPE_CD
         ELSE 'NA' END                          AS INTEL_PROP_FLG --124 知识产权产业类型代码
        ,CASE WHEN A.LOAN_BIZ_TYP NOT LIKE '01%' THEN M2.SFTXWHCYDL
              WHEN A.DATA_SRC IN ('零售贷款') AND B.CUL_PROPERTY_FLG = '1' THEN 'Y'
              WHEN A.DATA_SRC IN ('对公联合网贷') AND A.LOAN_DIR_IDY = FF.CODE THEN 'Y'
              ELSE 'N'
          END                                   AS CUL_PROPERTY_FLG                    --125 是否投向文化产业大类
        /*,CASE WHEN A.LOAN_BIZ_TYP NOT LIKE '01%'
              THEN M2.SFFDB
          END                                   AS REV_GUAR_FLG                        --126 是否反担保*/
        ,M3.SFFDBCS                             AS REV_GUAR_FLG                        --126 是否反担保
        ,CASE WHEN A.LOAN_BIZ_TYP NOT LIKE '01%'
              THEN M2.DKCZFCFS
          END                                   AS FIN_SUP_WAY_TYPE                    --127 贷款财政扶持方式
        ,CASE WHEN A.LOAN_BIZ_TYP NOT LIKE '01%'
              THEN M2.SFNYCYHLTQY
          END                                   AS LEAD_AGRI_FLG                       --128 是否农业产业化龙头企业
        ,CASE WHEN A.LOAN_BIZ_TYP NOT LIKE '01%'
              THEN M2.SFYQ
          END                                   AS DELINE_FLG                          --129 是否延期
        ,CASE WHEN A.LOAN_BIZ_TYP NOT LIKE '01%'
              THEN M2.SFWLCZGSCP
          END                                   AS FIN_SUB_COR_FLG                     --130 是否为理财子公司产品
        ,NVL(E.OPR_CRDT_TOT_AMT,0)              AS OPR_CRDT_TOT_AMT                    --131 经营授信总额 ADD BY 于敬艺 20230103
        ,NVL(E.CRDT_TOTAL_LMT,0)-NVL(E.OPR_CRDT_TOT_AMT,0) AS CON_CRDT_TOT_AMT         --132 消费授信总额 ADD BY 于敬艺 20230103 授信总额度-经营授信总额=消费授信总额
        ,NVL(A.DSBR_FARM_FLG,'N')               AS DSBR_FARM_FLG                       --133 放款时农户标志 ADD BY 于敬艺
        ,A.OPER_ORG_ID                          AS OPER_ORG_ID                         --134 经办机构编号 ADD BY 周一威 20230113
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') 
              AND M2.TXZLXXXCYML IN ('C','D','E','F','G','H','I','J','K') THEN 'Y'
              WHEN A.DATA_SRC NOT IN ('对公信贷','票据贴现','票据转贴现') AND B.STRATE_NEW_INDUS_TYPE_CD IN ('1','2','3','4','5','6','7','8','9') THEN 'Y'
              ELSE 'N'
          END                                   AS STRATE_NEW_INDUS_FLG                --135 战略性新兴产业标志
        ,CASE WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') THEN M2.TXZLXXXCYML
              ELSE CASE B.STRATE_NEW_INDUS_TYPE_CD
                        WHEN '7' THEN 'C' --节能环保
                        WHEN '1' THEN 'D' --新一代信息技术
                        WHEN '4' THEN 'E' --生物医药
                        WHEN '2' THEN 'F' --高端装备制造
                        WHEN '6' THEN 'G' --新能源
                        WHEN '3' THEN 'H' --新材料
                        WHEN '5' THEN 'I' --新能源汽车
                        WHEN '8' THEN 'J' --数字创意产业
                        WHEN '9' THEN 'K' --相关服务业
                        ELSE 'NA' END
          END                                   AS STRATE_NEW_INDUS_TYPE_CD            --136 战略性新兴产业类型代码
        ,CASE --WHEN A.LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN
              --DECODE(B.MAIN_GUA_MODE,'1','DZY','2','DZY','3','BZ','4','XY','Z')
              WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') AND B.SUB_GUA_MODE IN ('3','4','5','6','7','8')
              --3-抵押 4-质押 5-保证+抵押 6-保证+质押 7-抵押+质押 8-保证+抵押+质押
              THEN 'DZY' --抵质押贷款
              WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') AND B.SUB_GUA_MODE = '2' --2-保证
              THEN 'BZ' --保证贷款
              WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') AND B.SUB_GUA_MODE = '1' --1-信用
              THEN 'XY' --信用贷款 --对公
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷')
              AND (B.MAIN_GUA_MODE IN ('1','2') OR B.SUB_GUA_MODE IN ('3','4','5','6','7','8','A','B'))--3-抵押 4-质押 5-保证+抵押 6-保证+质押 7-抵押+质押 8-保证+抵押+质押
              THEN 'DZY' --抵质押贷款
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷') AND (B.MAIN_GUA_MODE = '3' OR B.SUB_GUA_MODE IN ('2','C'))--2-保证
              THEN 'BZ' --保证贷款
              WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷') AND (B.MAIN_GUA_MODE = '4' OR B.SUB_GUA_MODE IN ('1','D')) --1-信用
              THEN 'XY' --信用贷款 --个人
              ELSE 'Z'
          END                                   AS TJDBFS                              --137 统计担保方式
        ,CASE WHEN A.LOAN_STD_PROD_ID IN ('201020100024','201020100014','201020100051','201020100052','201020100064')--MOD BY LWB
                   AND D.OPR_CUST_TYP = 'Z'
                   AND NVL((CASE WHEN A.CUST_ID = '1201235888' AND A.LOAN_ACT_DSTR_DT > '20240331' THEN DD.FARM_FLG
                                 WHEN A.CUST_ID IN ('1012880707','1201235888') THEN 'N'
                                 WHEN A.CUST_ID = DD.CUST_ID THEN NVL(DD.FARM_FLG,'N')
                                 ELSE NULL END),'N') = 'N'
              THEN '1'
              WHEN A.DATA_SRC = '零售贷款' AND A.CUST_ID = DD.CUST_ID AND DD.FARM_FLG = 'N'
                   AND A.LOAN_ACT_DSTR_DT > '20250430'
                   AND D.NO_BUSLICS_PRC_FLG = 'Y'
              THEN '1'
              WHEN A.LOAN_STD_PROD_ID = '202020200001' AND A.CUST_ID = DD.CUST_ID AND DD.FARM_FLG = 'N'
                   AND D.NO_BUSLICS_PRC_FLG = 'Y'
              THEN '1'
              ELSE '0'
          END                                   AS QTGRFNH                             --138 其他个人非农户标识 1-是 0-否  MODIFY BY HYF in 20250704
        ,A.ICMS_CUST_ID                         AS CNTPTY_ID                           --139 交易对手编号
        ,CASE WHEN ZTXTMP.ZTXJJ IS NOT NULL THEN ZTXTMP.DIR_INDUS_CD
              WHEN A.DATA_SRC = '票据转贴现' AND A.LOAN_DIR_IDY = 'Z' THEN S.CUST_BLNG_IDY
              ELSE A.LOAN_DIR_IDY
          END                                   AS G19_DIR_IDY                         --140 G19专用投向行业
        ,A.LOAN_TYPE_CD                         AS LOAN_TYPE_CD                        --141 借据类型代码
        ,CASE WHEN A.DATA_SRC = '票据转贴现' AND A.SYS_IN_FLG = '0' AND A.LOAN_STD_PROD_ID = '204010100001' THEN '银行承兑汇票贴现' --ADD BY 20250310
              WHEN A.DATA_SRC = '票据转贴现' AND A.SYS_IN_FLG = '0' AND A.LOAN_STD_PROD_ID = '204010100002' THEN '商业承兑汇票贴现'
              ELSE A.LOAN_PROD_NM
          END                                   AS STD_PROD_NM                         --142 标准产品名称
        ,M2.SFWJY                               AS SFWJY                               --143 是否玩具业
        ,M2.WJHYMC                              AS WJHYMC                              --144 玩具业行业名称
        ,M2.SFZFZDXM                            AS SFZFZDXM                            --145 是否政府重点项目
        ,M2.SFSQQY                              AS SFSQQY                              --146 是否涉侨企业
        ,M2.GYLRZQY                             AS GYLRZQY                             --147 供应链融资企业
        ,M2.SFTXHSFDCY                          AS SFTXHSFDCY                          --148 是否投向海上风电产业
        ,M2.SFTXXXCNCY                          AS SFTXXXCNCY                          --149 是否投向新型储能产业
        ,CASE WHEN A.DATA_SRC = '对公信贷' AND A.LOAN_FRM IN ('05','9906') AND A.RCMM_LOAN_FLG = 'Y' THEN 'Y'
              WHEN A.DATA_SRC = '对公信贷' AND A.LOAN_FRM = '04' THEN 'Y' 
              WHEN A.RCMM_LOAN_FLG = 'Y' THEN A.RCMM_LOAN_FLG
         ELSE 'N' END                           AS REGROUP_LOAN_FLG                    --150 重组贷款标志
        ,NVL(A.REGROUP_LOAN_TYPE_CD,'-')        AS REGROUP_LOAN_TYPE_CD                --151 重组贷款类型代码
        ,CASE WHEN NVL(A.REGROUP_LOAN_TYPE_CD,'-') = '01' THEN '借新还旧'
              WHEN NVL(A.REGROUP_LOAN_TYPE_CD,'-') = '02' THEN '展期'
              WHEN NVL(A.REGROUP_LOAN_TYPE_CD,'-') = '03' THEN '还款计划变更'
              WHEN NVL(A.REGROUP_LOAN_TYPE_CD,'-') = '04' THEN '债务重组'
              ELSE '未知'
          END                                   AS REGROUP_LOAN_TYPE_NAME              --152 重组贷款类型名称
        ,CASE WHEN A.ORG_ID LIKE '805%' THEN 'N'--MODIFY BY HYF 20251113 深圳分行统一非农户
              WHEN A.LOAN_STD_PROD_ID IN ( '202010100006','202010100008','202020100003') THEN 'N'--MODIFY BY LWB 20250318 微粒贷统一非农户
              WHEN A.CUST_ID ='1201235888' AND A.LOAN_ACT_DSTR_DT > '20240331' THEN DD.FARM_FLG--S_LOAN4月放款数据按照客户1201235888系统出数
              WHEN A.CUST_ID IN ('1012880707','1201235888') THEN 'N'
              WHEN A.CUST_ID = DD.CUST_ID THEN NVL(DD.FARM_FLG,'N')
              ELSE NULL
          END                                   AS FKSSNBZ                             --153 放款时涉农标志
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' THEN 'A'--ADD BY 20241209
              WHEN A.LOAN_STD_PROD_ID = '201020100049' AND A.LOAN_ACT_DSTR_DT < '20241101' THEN 'Z'
              WHEN A.CUST_ID = DD.CUST_ID THEN NVL(DD.OPR_CUST_TYP,'Z')
              ELSE NULL
          END                                   AS FKSKHLX                             --154 放款时客户类型
        ,CASE WHEN B.DATA_SRC = '对公信贷'AND B.STD_PROD_ID = '203010200005' THEN 'Y'
              ELSE 'N'
          END                                   AS SFJSGZXMDK                          --155 是否技术改造项目贷款 ADD YJY IN 20240206
        ,M2.SFJGMDZDZJTXZXQY                    AS SFJGMDZDZJTXZXQY                    --156 是否监管名单中的专精特新中小企业 ADD YJY IN 20240220
        ,CASE WHEN A.DATA_SRC = '对公信贷' AND B.PROVI_FOR_AGED_PROPERTY_FLG = '1' THEN 'Y'
              WHEN A.DATA_SRC = '对公信贷' AND B.PROVI_FOR_AGED_PROPERTY_FLG = '0' THEN 'N'
              WHEN A.DATA_SRC = '对公信贷' AND DECODE(SUBSTR(NVL(TRIM(B.PROVI_FOR_AGED_PROPERTY_FLG),'999'),1,3),'999','0','-','0','1') = '1'
              THEN 'Y'
/*              WHEN A.DATA_SRC = '零售贷款' AND A.PROVI_FOR_AGED_PROPERTY_FLG = '1' THEN 'Y'
              WHEN A.DATA_SRC = '零售贷款' AND A.PROVI_FOR_AGED_PROPERTY_FLG = '0' THEN 'N'
              WHEN A.DATA_SRC = '零售贷款' AND DECODE(SUBSTR(NVL(TRIM(A.PROVI_FOR_AGED_PROPERTY_FLG),'999'),1,3),'999','0','-','0','1') = '1' THEN 'Y'*/
              WHEN A.DATA_SRC = '零售贷款' AND B.PROVI_FOR_AGED_PROPERTY_FLG = '1' THEN 'Y'
              WHEN A.DATA_SRC = '零售贷款' AND B.PROVI_FOR_AGED_PROPERTY_FLG = '0' THEN 'N'
              WHEN A.DATA_SRC = '零售贷款' AND DECODE(SUBSTR(NVL(TRIM(B.PROVI_FOR_AGED_PROPERTY_FLG),'999'),1,3),'999','0','-','0','1') = '1' THEN 'Y'                
              ELSE 'N'
          END                                   AS SFYLCY                              --157 是否养老产业 MDF HYF 20250731 --999999码值是否
        ,C.REGD_LAND_AREA_CD                    AS REGD_LAND_AREA_CD                   --158 行政区划代码 ADD YJY IN 20240221
        ,CASE WHEN S66.REGD_LAND_AREA_CD IS NOT NULL THEN S66.CITY_SIZE_CODE
              ELSE ''
          END                                   AS CITY_SIZE                           --159 城市规模 ADD YJY IN 20240221
        ,A.LMT_CONT_ID                          AS LMT_CONT_ID                         --160 额度合同编号
        ,G.CONT_AMT                             AS LMT_CONT_AMT                        --161 额度合同金额
        ,M2.SFTXZFHSHZBHZ_PPP_XM                AS SFTXZFHSHZBHZ_PPP_XM                --162 是否投向政府和社会资本合作（PPP）项目
        ,M2.SFXJZFFDK                           AS SFXJZFFDK                           --163 是否新机制发放贷款
        ,CASE WHEN A.DATA_SRC = '零售贷款' AND NVL(A.EXTN_CNT,0) > 0 AND A.LOAN_STD_PROD_ID <> '202010100004'
               AND A.RENEW_EXP_DAY > V_P_DATE THEN 'Y'
              ELSE NVL(A.RENEW_FLG_WDQ,'N')
          END                                   AS RENEW_FLG_WDQ                       --164 展期未到期标志 --add by lwb 20240408
        ,CASE WHEN A.LOAN_STD_PROD_ID IN ('203040400001') AND A.LOAN_ACT_DSTR_DT = A.LOAN_ACT_EXP_DT
              THEN 'Y'
              WHEN A.LOAN_STD_PROD_ID IN ('203040100001') AND A.LOAN_ACT_DSTR_DT = A.PAYOFF_DT
              THEN 'Y'
              ELSE 'N'
          END                                   AS S63_CSH_FLG                         --165 S63_贴现垫款过路垫款标志
        ,M2.SFYZLLDLYQWJFXM                     AS SFYZLLDLYQWJFXM                     --166 是否因资金链断裂导致的逾期未交付项目
        ,DECODE(B.SEED_LOAN_FLG,'1','Y','N')    AS SEED_LOAN_FLG                       --167 种业振兴贷款标志
        ,DECODE(B.COUNTY_LOAN_FLG,'1','Y','N')  AS COUNTY_LOAN_FLG                     --168 县城区贷款标志
        ,DECODE(NVL(TRIM(B.CUL_AND_RELA_PPTY_TYPE_CD),'-'),'-','NA','99','NA',TRIM(B.CUL_AND_RELA_PPTY_TYPE_CD)) AS CUL_AND_RELA_PPTY_TYPE_CD       --169 文化及相关产业类型代码
        ,CASE WHEN CCC.ENT_SCALE  IN ('L','M','S','X') THEN CCC.ENT_SCALE --放款时点
              WHEN CCC.ENT_SCALE  NOT IN ('L','M','S','X') AND C.ENT_SCALE IN ('L','M','S','X') THEN C.ENT_SCALE --当前时点
              WHEN A.DATA_SRC='票据转贴现' AND NVL(CCC.ENT_SCALE,C.ENT_SCALE) NOT IN ('L','M','S','X')
              THEN 'M'
              WHEN A.DATA_SRC='票据转贴现' AND NVL(CCC.ENT_SCALE,C.ENT_SCALE) IS NULL
              THEN 'M'
          END                                   AS FKSQYGM                              --170 放款时企业规模
        ,M2.SFYZLLDLYQWJFXMKFRZ  AS SFYZLLDLYQWJFXMKFRZ                                 --171 是否因资金链断裂导致的逾期未交付项目_开发融资
        ,M2.SFYZLLDLYQWJFXMKFRZDK AS SFYZLLDLYQWJFXMKFRZDK                              --172 是否因资金链断裂导致的逾期未交付项目_开发融资_贷款
        ,A.LOAN_ACT_EXP_DT                      AS LOAN_ACT_EXP_DT                      --173 贷款实际到期日期
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' --ADD BY 20241209
              THEN 'A'
              ELSE D.OPR_CUST_TYP_WSD
          END                                   AS OPR_CUST_TYP_DJZ                     --174 经营客户类型_大集中
        ,D.CUST_NM_WSD                          AS CUST_NM_WSD                          --175 客户名称_网商贷
        ,CASE WHEN A.LOAN_STD_PROD_ID = '203030500015' AND C.CUST_CL = 'E' --ADD BY 20241209
              THEN 'A'
              ELSE D.OPR_CUST_TYP_WSD
          END                                   AS OPR_CUST_TYP_WSD_RH                  --176 时点客户类型_人行
        ,CASE WHEN A.DATA_SRC = '票据贴现'
              THEN (CASE WHEN OVD.OVD_DAYS = 0 THEN '0D'
                         WHEN OVD.OVD_DAYS > 0   AND OVD.OVD_DAYS <= 30  THEN '30D'  --逾期30天以内
                         WHEN OVD.OVD_DAYS > 30  AND OVD.OVD_DAYS <= 60  THEN '60D'  --逾期31天到60天
                         WHEN OVD.OVD_DAYS > 60  AND OVD.OVD_DAYS <= 90  THEN '90D'  --逾期61天到90天
                         WHEN OVD.OVD_DAYS > 90  AND OVD.OVD_DAYS <= 180 THEN '180D' --逾期91天到180天
                         WHEN OVD.OVD_DAYS > 180 AND OVD.OVD_DAYS <= 270 THEN '270D' --逾期181天到270天
                         WHEN OVD.OVD_DAYS > 270 AND OVD.OVD_DAYS <= 360 THEN '360D' --逾期271天到360天
                         WHEN OVD.OVD_DAYS > 360 THEN '365D' --逾期361天以上
                         ELSE '0D'
                     END)
              ELSE (CASE WHEN A.OVD_DAYS = 0 THEN '0D'
                         WHEN A.OVD_DAYS > 0   AND A.OVD_DAYS <= 30  THEN '30D'  --逾期30天以内
                         WHEN A.OVD_DAYS > 30  AND A.OVD_DAYS <= 60  THEN '60D'  --逾期31天到60天
                         WHEN A.OVD_DAYS > 60  AND A.OVD_DAYS <= 90  THEN '90D'  --逾期61天到90天
                         WHEN A.OVD_DAYS > 90  AND A.OVD_DAYS <= 180 THEN '180D' --逾期91天到180天
                         WHEN A.OVD_DAYS > 180 AND A.OVD_DAYS <= 270 THEN '270D' --逾期181天到270天
                         WHEN A.OVD_DAYS > 270 AND A.OVD_DAYS <= 360 THEN '360D' --逾期271天到360天
                         WHEN A.OVD_DAYS > 360 THEN '365D' --逾期361天以上
                         ELSE '0D'
                     END)
           END                                 AS OVD_LOAN_TERM                        --177 逾期期限
        ,A.SUIT_FEE_BAL                        AS SUIT_FEE_BAL                         --178 诉讼费余额
        ,C.INOVT_MED_SIDE_ENTER_FLG            AS INOVT_MED_SIDE_ENTER_FLG             --179 创新型中小企业标志 ADD BY HYF 20250310
        ,C.CTY_CORP_TECH_CENTER_FLG            AS CTY_CORP_TECH_CENTER_FLG             --180 国家企业技术中心标志 ADD BY HYF 20250310
        ,C.EACH_CLASS_SCEN_TECH_LIST_CORP_FLG  AS EACH_CLASS_SCEN_TECH_LIST_CORP_FLG   --181 各类科技名单企业标志 ADD BY HYF 20250310
        ,CASE WHEN A.SYS_IN_FLG = '0'  THEN 'Y' ELSE 'N' END                           --0系统内 1系统外
                                               AS SYS_IN_FLG                           --182 系统外标志 ADD BY HYF 20250310
        ,C.CTY_TECH_INOVT_CORP_FLG             AS CTY_TECH_INOVT_CORP_FLG              --183国家技术创新示范企业标志 ADD BY LWB
        ,C.ITEM_CORP_FLG                       AS ITEM_CORP_FLG                        --184 制造业单项冠军企业标志 ADD BY LWB
        ,CASE WHEN A.LOAN_ACT_DSTR_DT > = '20250301' AND A.ACURT_POV_ALLE_LOAN_FLG IN ('Y','N') THEN 'Y'
         ELSE 'N' END                          AS YJDLKPKH                             --185 原建档立卡贫困户标志 ADD BY HYF 20250324
        ,NVL(C.CORP_CERT_NO,D.CORP_CERT_NO)    AS CORP_CERT_NO                         --186 借据层企业统一社会信用代码 ADD BY HYF 20250415
        ,COALESCE(D.INDV_BUS_NAME,D.CORP_NAME,C.INDV_BUS_NAME) AS CORP_NAME            --187 借据层企业名称 ADD BY HYF 20250415
        ,ZTXTMP.OLD_CONT_ID                    AS OLD_CONT_ID                          --188 原合同号 ADD BY HYF 20250415
        ,CASE WHEN Q.RCPT_ID IS NOT NULL THEN Q.ORG_ID
         ELSE A.ORG_ID END                     AS FK_ORG_ID                            --189 累放层机构号 ADD BY HYF 20250514
        ,D.EX_SERVSM_FLG                       AS EX_SERVSM_FLG                        --190 退役军人标志 ADD BY HYF 20250514
        ,D.NO_BUSLICS_PRC_FLG                  AS NO_BUSLICS_PRC_FLG                   --191 无营业执照负责人标志 ADD BY HYF 20250514
        ,CASE WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公联合网贷') AND B.HIGH_TECH_PROPERTY_TYPE_CD IN ('07')
              THEN 'Y'
              WHEN A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现') AND CODE4.CODE IS NOT NULL
              THEN 'Y'
              ELSE 'N'
          END                                   AS HIGH_TECH_IDY_SER_FLG               --192 高技术服务业标志  ADD BY HYF 20250902
         ,NVL(A.PROVI_FOR_AGED_PROPERTY_FLG,B.PROVI_FOR_AGED_PROPERTY_FLG)
                                                AS YLCYDM                              --193 养老产业代码 ADD BY HYF 20250902 
         ,ZTXTMP.TXJJ                           AS OLD_RCPT_ID                         --194 原借据号 ADD BY HYF 20250911  
         ,A.FND_PCT                             AS FND_PCT                             --195 本行出资比例 ADD BY HYF 20251124  
         ,CASE WHEN A.FND_PCT IS NULL THEN NULL
          ELSE 100-A.FND_PCT END                AS FND_PCT_HZF                         --196 合作机构出资比例 ADD BY HYF 20251124 
         ,CASE WHEN NVL(CCC.ENT_HLDG_TYP,'-') <> '-' THEN CCC.ENT_HLDG_TYP
          ELSE C.ENT_HLDG_TYP END               AS FKSKGLX                             --197 放款时控股类型 
         ,A.BGDKLX                              AS BGDKLX                              --198 并购贷款类型 ADD BY HYF 20260319
         ,A.SFTYJRCBQY                          AS SFTYJRCBQY                          --199 是否退役军人创办企业 ADD BY HYF 20260319
        ,CASE WHEN CC.ENT_SCALE  IN ('L','M','S','X') THEN CC.ENT_SCALE  --放款月末
              WHEN CC.ENT_SCALE  NOT IN ('L','M','S','X') AND C.ENT_SCALE IN ('L','M','S','X') THEN C.ENT_SCALE --当前时点
              WHEN A.DATA_SRC='票据转贴现' AND NVL(CC.ENT_SCALE,C.ENT_SCALE) NOT IN ('L','M','S','X')
              THEN 'M'
              WHEN A.DATA_SRC='票据转贴现' AND NVL(CC.ENT_SCALE,CCC.ENT_SCALE) IS NULL
              THEN 'M'
          END                                   AS FKYQYGM                             --200 放款月企业规模 ADD BY HYF 20260319         
         ,CASE WHEN NVL(CC.ENT_HLDG_TYP,'-') <> '-' THEN CC.ENT_HLDG_TYP --放款月末
          ELSE C.ENT_HLDG_TYP END               AS FKYKGLX                             --201 放款月控股类型 ADD BY HYF 20260319
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
    LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO B --贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息表
      ON C.CUST_ID = (CASE WHEN A.DATA_SRC = '票据转贴现' THEN NVL(A.DISCNT_CUST_ID,'-')
                           WHEN A.LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN A.LC_BENEFC --二级福费廷取受益人
                           ELSE A.CUST_ID
                       END)
     AND C.DATA_DT = V_P_DATE --当前时点
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO CC --对公客户信息表
      ON CC.CUST_ID = (CASE WHEN A.DATA_SRC = '票据转贴现' THEN NVL(A.DISCNT_CUST_ID,'-')
                           WHEN A.LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN A.LC_BENEFC --二级福费廷取受益人
                           ELSE A.CUST_ID
                       END)
     AND CC.DATA_DT = TO_CHAR(LAST_DAY(TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')),'YYYYMMDD')--取放款日期对应月末时点
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO CCC --对公客户信息表
      ON CCC.CUST_ID = (CASE WHEN A.DATA_SRC = '票据转贴现' THEN NVL(A.DISCNT_CUST_ID,'-')
                           WHEN A.LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN A.LC_BENEFC --二级福费廷取受益人
                           ELSE A.CUST_ID
                       END)
     AND CCC.DATA_DT = A.LOAN_ACT_DSTR_DT--取放款日期对应的客户属性
    LEFT JOIN RRP_MDL.S66_CITY_SIZE S66 --S66城市规模码值表   --ADD YJY IN 20240221
      ON S66.REGD_LAND_AREA_CD = C.REGD_LAND_AREA_CD
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      ON D.CUST_ID = A.CUST_ID
     AND D.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO DD --个人客户信息
      ON DD.CUST_ID = A.CUST_ID
     AND DD.DATA_DT = (CASE WHEN A.LOAN_ACT_DSTR_DT >= '20231231'
                            THEN TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD'),'MM')-1,1),'YYYYMMDD')
                            ELSE '20231231'
                        END)--MODIFY BY LWB 以20231231为界限，之后的数据取放款日当月月末的客户信息，之前的直取20231231的客户标识
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
      ON E.CUST_ID = (CASE WHEN A.DATA_SRC = '票据转贴现' THEN NVL(A.DISCNT_CUST_ID,'-')
                           ELSE A.CUST_ID END)
     AND E.DATA_DT = V_P_DATE
    LEFT JOIN ICL.V_CMM_INDV_CUST_ATTACH_INFO DDD
      ON DDD.CUST_ID = A.CUST_ID
     AND DDD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CMM_CORP_LOAN_REPAY_DTL F
      ON F.DUBIL_ID = A.RCPT_ID
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO J --机构表
      ON J.ORG_ID = A.ORG_ID
     AND J.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_ADD_DG_003_MONEY M2 --补录表-对公-账务基表
      ON M2.JYWYM = A.RCPT_ID
     AND M2.DATA_DATE = V_P_DATE
    LEFT JOIN RRP_MDL.CONFIG_AREA Z1 --中国行政区划2020
      ON Z1.NEW_AREA_CD = J.REGD_LAND_AREA_CD
    LEFT JOIN RRP_MDL.CONFIG_AREA Z2 --中国行政区划2020
      ON Z2.NEW_AREA_CD = C.REGD_LAND_AREA_CD
    LEFT JOIN RRP_MDL.CONFIG_AREA Z3 --中国行政区划2020
      ON Z3.NEW_AREA_CD = D.RSDNC_AREA_CD
    LEFT JOIN RRP_MDL.M_BILL_INFO P --票据票面信息
      ON P.BILL_NO = A.BILL_NO
     AND P.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT TTT.*,ROW_NUMBER() OVER (PARTITION BY KHWYM ORDER BY BXCDJMFYLB) AS RN
                 FROM RRP_MDL.M_ADD_DG_001_CUST TTT) M1 --补录表-对公-客户基表（应急处理，KHWYM客户唯一码存在重复，后面修改）
      ON M1.KHWYM = (CASE WHEN A.DATA_SRC = '票据转贴现' THEN NVL(A.DISCNT_CUST_ID,'-')
                          WHEN A.LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN A.LC_BENEFC
                          ELSE A.CUST_ID END)
     AND M1.RN = 1
     AND M1.DATA_DATE = V_P_DATE
    LEFT JOIN RRP_MDL.M_ADD_DG_012_FINANCE_GUARAN M3
      ON M3.JYWYM = A.RCPT_ID
     AND M3.DATA_DATE = V_P_DATE
    LEFT JOIN RRP_MDL.M_ADD_LS_014_FINANCE_GUARAN M4
      ON M4.JYWYM = A.RCPT_ID
     AND M4.DATA_DATE = V_P_DATE
    LEFT JOIN RRP_MDL.M_INDUSTRY_CLASSIFY EE --G19行业类别分类表
      ON EE.INDUS_CATE_CD = A.LOAN_DIR_IDY
     AND EE.CLASSIFY = '战略新兴'
    LEFT JOIN RRP_MDL.M_DICT_G19_REMAPPING FF --G19行业映射关系表
      ON FF.CODE = A.LOAN_DIR_IDY
     AND FF.TYPE_CODE = 'G1901' --文化及相关产业
    LEFT JOIN RRP_MDL.M_DICT_G0107_REMAPPING_BL GG --G19行业映射关系表
      ON GG.NAME = M2.ZSCQMJXCYMC
     AND GG.TYPE_CODE = 'G010703' --知识产权密集型产业
    LEFT JOIN (SELECT A.CUST_ID --客户号
                     ,A.BUSINFOEXISTFLAG --是否有效工商信息
                     ,ROW_NUMBER() OVER (PARTITION BY CUST_ID ORDER BY APP_DT DESC ) AS RN
                 FROM RRP_MDL.M_LOAN_APP_INFO A --贷款申请信息
                WHERE A.DATA_DT = V_P_DATE) APP
      ON APP.CUST_ID = A.CUST_ID
     AND APP.RN = 1
    LEFT JOIN RRP_MDL.M_ADD_LS_003_MONEY EY
      ON EY.JYWYM = A.RCPT_ID
     AND EY.DATA_DATE = V_P_DATE
    LEFT JOIN TMP1 T10
      ON T10.CUST_ID = NVL(A.DISCNT_CUST_ID,'-')--转贴现特殊处理
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
      ON O.V_TRADE_NO = A.BILL_NO --MODIFY BY MW 20221209 根据源系统口径改为BILL_ID关联
      --ON O.V_TRADE_NO = A.BILL_NUM
     AND O.V_BUSINESSTYPE = A.LOAN_STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO S --对公客户信息表
      ON S.CUST_ID = A.ICMS_CUST_ID
     AND S.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO G  --对公贷款合同信息  MODIFY BY YJY 20240222 再关联回合同表的合同号，拿合同金额就是额度合同的金额
      ON G.CONT_ID = A.LMT_CONT_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DISTINCT CUST_ID,CUST_NAME,OPR_CUST_TYP_WSD_RH FROM RRP_MDL.GTXW_DJZ) DJZ
      ON DJZ.CUST_ID = A.CUST_ID
    LEFT JOIN TMP2 OVD
      ON OVD.RCPT_ID = A.RCPT_ID
    LEFT JOIN RRP_MDL.ZTXTMP ZTXTMP --系统内转贴
      ON ZTXTMP.ZTXJJ = A.RCPT_ID
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO ZTX_GREEN --系统内转贴现的绿色贷款标志需要取转贴现借据对应贴现票据的绿色贷款属性判断 --MOD BY HYF 20250813
      ON ZTX_GREEN.RCPT_ID = ZTXTMP.TXJJ
     AND ZTX_GREEN.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.CODE_MAP CODE3 --配置表
      ON CODE3.SRC_VALUE_CODE = NVL(ZTXTMP.DIR_INDUS_CD,A.LOAN_DIR_IDY)
     AND CODE3.SRC_CLASS_CODE = 'P0003'--行业分类
     AND CODE3.TAR_CLASS_CODE = 'T0025'--高技术产业（制造业）分类
     AND CODE3.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT CODE,NAME FROM RRP_MDL.M_DICT_G0107_REMAPPING_BL 
               WHERE TYPE_CODE = 'G010701'
               AND CYML = '服务业'
               AND SFDX = 'N' --剔除带*
               ) CODE4 --高技术服务业   
      ON CODE4.CODE = NVL(ZTXTMP.DIR_INDUS_CD,A.LOAN_DIR_IDY)  
    LEFT JOIN RRP_MDL.S_S6301_891_RCPT_INFO Q --891机构账务前移前借据配置表
      ON Q.RCPT_ID = A.RCPT_ID
   WHERE NVL(A.LOAN_BIZ_TYP,'0') NOT IN ('90','99') --剔除委托贷款、非标其他债券
     AND SUBSTR(A.LOAN_STD_PROD_ID,0,1) <> '4' --MOD 20230522 剔除同业法人透支
     AND A.AD_CSH_FLG = 0 --剔除过滤垫款
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款业务整合表--查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.S_LOAN T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN;
/

