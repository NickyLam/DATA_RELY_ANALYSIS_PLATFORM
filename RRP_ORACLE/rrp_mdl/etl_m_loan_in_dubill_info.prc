CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_IN_DUBILL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_IN_DUBILL_INFO
  *  功能描述：表内借据信息-所有以个人客户和机构名义开展信贷业务时所签订的信贷业务借据信息（仅表内部分+委托贷款），不含信用卡业务。
  *  核销、转让如果余额不为0，接数时，处理为0
  *  创建日期：20220519
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_IN_DUBILL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220519  梅炜    首次创建
  *             2    20220823  许晓滨  修复标准产品码值
  *             3    20220824  HULJ    修改票据号
  *             4    20220824  许晓滨  首贷标志字段修复,零售，联合贷贷款用途映射
  *             5    20220906  许晓滨  新增口径
  *             6    20220921  HULJ    加工客户的首笔借据及首次放款日期
  *             7    20220922  HULIJ   新增逻辑对公贷款贴现部分，对公贷款买断式转贴现部分
  *             8    20220924  MW      修改贷款投向行业取值，修改贴现、转贴现口径
  *             9    20221028  HULJ    联合网贷部分过滤掉账户>0的数据,计息方式代码调整,
  *             10   20221103  MW      修改项目贷款判定，经营性物业贷款改为一般固定资产贷款
  *             11   20221105  MW      增加贷款投向境内外标识及逻辑
  *             12   20221107  HULJ    零售贷款剔除转让数据,调整联合网贷销户日期,信贷员工号,标准产品编号取值,增加数据重复校验
  *             13   20221108  HULJ    调整联合网贷销户日期取值,调整零售贷款部分三方,四方增信模式口径,绿色贷款标志剔除出口代付、进口代付
  *                                    模型层去掉核销部分过滤条件,各模块根据报送要求用销户日期卡条件
  *                                    贷款投向地区补充客户的地区代码，身份证类型判断时加上临时身份证
  *                                    项目贷款标志剔除经营性物业贷款,增加并购贷款,入账账号补充承兑垫款的取票据的出票人账号
  *             14   20221113  LHQ　   调整贴现口径贴现状态取值
  *             15   20221121  LHQ     修改贷款形式该字段取值，参考EAST5.0口径修改
  *             16   20221122  HULJ    新增经办机构、经办柜员、本行首贷日期、展期到期日期字段,
  *                                    修改原机构、柜员逻辑,调整零售部分零售产品和用途映射关系
  *             17   20221123  HULJ    新增征信首贷日期、借据主办客户经理号、借据主办柜员号、借据主办客户经理名称、借据主办客户经理所属机构
  *             18   20221123  MW      根据评审结果修改，1、增加核销日期字段,2、增加表内利息、表外利息字段
  *             19   20221227  MW      修改出资比例字段逻辑,调整代码排版
  *             20   20221229  MW      新增放款日期、放款金额字段
  *             21   20230203  MW      调整首贷日逻辑，接入联合网贷往期结清数据
  *             22   20230424  XUXIAOBIN      贴现逻辑调整，演练4发现条件有问题
  *             23   20230509  XUXIAOBIN      RATE_RE_PRC_DT 对公部分口径，该字段逻辑调整，00010101 20991231置空
  *             24   20230523  WEIYONGZHAO    调整以下字段逻辑：网贷产品类别  NET_LOAN_PROD_TYP、互联网贷款标志  NET_LOAN_FLG、出资比例  FND_PCT
  *             25   20230524  MW       调整对公法透部分合同号取值，对公法透从核心取合同号
  *             26   20230527  LIP     调整入账账号、入账户名、入账行名、还款账号、还款行名口径
  *             27   20230531  LIP     调整个人贷款贷款投向地区的取数口径：自营按照贷款业务所在的机构所在地  联合网贷就还是按照旧逻辑
  *             28   20230703  HYF     调整所有个贷+联合网贷产品逾期本金金额字段的取数需调整为逾期本金+呆滞本金
  *             30   20230711  HYF     修改转贴现部分直贴人客户号逻辑
  *             31   20230724  MW      修改对公信贷部分循环贷标志判断逻辑
  *             32   20230728  HULJ    新增福费廷需求6个字段
  *             33   20230810  LIP     新增信贷系统的基准利率
  *             34   20230816  HULJ    循环贷增加两个产品
  *             35   20230828  LIP     调整承兑垫款的入账账号信息
  *             36   20230829  LIP     调整对公、零售贷款的当前期数，累计欠款期数和连续欠款期数
  *             37   20230901  HULJ    新增资产证券化标志、资产转让标志字段
  *             38   20230914  HULJ    新增债权直转标志，调整贷款类型逻辑接入借据类型代码
  *             39   20230918  HYF     修改涉农贷款标志，转贴现和贴现都默认为非涉农
  *             40   20231016  HYF     修改转贴现部分直贴人过滤条件，中文括号替换为英文括号
  *             41   20231207  HULJ    调整贷款原始到期日期，零售部分口径取展期前的原始到期日
  *             42   20231228  HULJ    零售部分口径新增重组贷款标志、重组贷款类型代码
  *             43   20240111  HYF     修改转贴现部分直贴人客户号取值逻辑，对客户号就行去重
  *             44   20240204  LYH     非标其他债券段 增加交易对手客户号字段
  *             45   20240306  LWB     修改联合网贷循环贷标志，网商贷产品不为循环贷
  *             46   20240401  YJY     对公部分新增置换旧债标志
  *             47   20240408  LWB     新增展期未到期标志（仅针对对公信贷）
  *             48   20240507  YJY     新增养老产业标志，加工零售部分逻辑
  *             49   20240611  LWB     修改零售贷款部分的循环贷标志
  *             50   20240702  YJY     调整联合网贷部分的表内外欠息字段取值，需要加上罚息
  *             51   20240703  LWB     零售循环贷加上饲料E贷的两个产品
  *             52   20240704  LIP     网商贷3.0调整网商贷部分的原始到期日，重组，展期等相关字段，调整京东的EAST口径标识
  *             53   20240717  LIP     网商贷3.0、100%出资（有保）调整出资比例
  *             54   20240717  LIP     将借新还旧的原借据号拼接起来插入原借据号字段
  *             55   20240910  LIP     优化联合网贷部分借据状态逻辑
  *             56   20241010  YJY     联合网贷部分新增发生方式字段
  *             57   20241021  LIP     203030200001-国内信用证项下议付、203030600001-国内信用证项下福费廷产品的交易对手取数口径调整
  *             58   20241022  YJY     新增结清日期字段
  *             59   20241029  HYF     修改微粒贷为非循环贷
  *             60   20241106  HYF     修改境内外标志BIO_LOAN_FLG、LOAN_DIR_BIO_FLG
  *             61   20241122  LIP     增加票据贴现和转贴现的结清日期加工口径
  *             62   20241210  HYF     调整零售贷款部分逾期类型，从核心账户表出数
  *             63   20241216  YJY     调整零售贷款部分互联网标识逻辑：优先判断尽调标志为否的则为互联网贷款业务
  *             64   20241217  YJY     新增诉讼费余额
  *             65   20250103  YJY     1)调整对公部分的贷款形式，无还本续贷取信贷系统相关标签;
                                       2)调整零售贷款部分新增华兴易贷（担保）产品默认为互联网贷款
                                       3)新增字节小微贷产品，调整“联合网贷”部分出资比例、入账账户开户行名称、还款账户开户行名称
                                       4)调整零售部分房抵贷（网商引流）的入账开户行名称、还款开户行名称暂时定义为‘支付宝’，调整EAST_口径标识，要比正常的日期-1
  *             66   20250206  YJY     调整联合网贷部分总期数
  *             67   20250213  YJY     1）新增对公互联网贷款-微业贷的逻辑；2）调整票据贴现产品编号关联条件
  *             68   20250303  YJY     调整‘对公信贷部分’的重组贷款标识字段
  *             69   20250310  LIP     调整华兴易贷的收付款账号及相关信息
  *             70   20250324  YJY     加工零售贷款部分诉讼费余额取值
  *             71   20250410  YJY     贴现、转贴现部分新增票据编号字段
  *             72   20250414  YJY     调整对公联合网贷-微业贷部分字段逻辑
  *             73   20250425  YJY     调整对公联合网贷-微业贷的额度合同号逻辑，从联合网贷额度合同表取授信额度合同号
  *             74   20250427  HYF     客户性质补上联合网贷部分逻辑
  *             75   20250508  YJY     1)对公信贷部分新增绿色信贷客户标志、绿色信贷分类_旧版代码、绿色信贷分类_新版代码
                                       2)调整CBRC绿色贷款标志
                                       3)调整对公联合网贷微业贷的标签，从联合网贷合同信息表中取
  *             76   20250521  YJY     调整联合网贷借据号逻辑，取核心借据号字段；新增第三方借据编号
  *             77   20250604  YJY     调整对公联合网贷（微业贷）的合同号，取真实合同号；调整PBOC绿色贷款标志、CBRC绿色贷款标志逻辑
  *             78   20250609  YJY     调整字节小微贷的贷款还款账号开户行名称，对还款账号和入账账号都进行不为空的判断
  *             79   20250613  YJY     新增联合网贷产品字节放心借202010200009
  *             80   20250613  LIP     按照严希婧口径，调整保理的入账账号相关信息取数口径
  *             81   20250709  LIP     调整201010300041华兴好易贷（华强）的部分字段的取数口径
  *             82   20250717  YJY     联合网贷部分1）新增分期乐系列产品：分期乐乐金卡，产品编码202010200011；分期乐消费，产品编号202010200010
                                                   2）新增唯品消金产品：202010100007
                                       零售贷款部分新增201020100062 饲料e贷-海大集团、兴采贷  201020100061，根据关联信贷‘标签值最终表’借据判断是否互联网业务
  *             83   20250725  LIP     回退核算改造版本
  *             84   20250805  YJY     根据业务沈路的口径调整华兴好易贷（担保） 201010300035和华兴好易贷（经营-担保）201020100059默认互联网贷款；华兴好易贷（经营-信用）201020100060判断尽调标志为否的则为互联网贷款业务
  *             85   20250819  YJY     PBOC绿色贷款标志和CBRC绿色贷款标志保持一致，取绿色信贷分类_新版代码
  *             86   20250820  YJY     联合网贷部分1)新增一个还款计划临时表，用于加工连续欠款期数、当前累计欠款期数
                                                   2)EAST口径标识字段需要对分期乐产品特殊处理  --0820修改的内容延期，详见1104修改内容
  *             87   20250826  YJY     新增零售自营产品202010200012-360借条，按照互联网贷款报送
  *             88   20250904  LAL     一表通，增加白户标志
  *             89   20250928  YJY     联合网贷的展期次数调整，与张家伟确认，除了有展期标志的，其他的不算展期
  *             90   20250916  PSF     一表通，增加一表通口径标识
  *             91   20251104  YJY     联合网贷部分1)新增一个还款计划临时表，用于加工连续欠款期数、当前累计欠款期数
                                                  2)EAST口径标识、一表通年口径字段需要对分期乐、微业贷3.0（好企贷-数据贷）产品特殊处理
                                                  3)微业贷3.0（好企贷-数据贷）通过行内贷款类型代码联合网贷/助贷类型
  *             92   20251104  LIP     贴现、转贴现部分保证金相关字段赋值
  *             93   20251105  ZLY     对于贷款余额为0且结清日期为29991231置N
  *             94   20251107  LIP     核心记账的借据，现在有当前期次大于总期数的情况，调整当前期次取数
  *             95   20251120  YJY     1)新增203050100002-微众对公联合贷（微业贷4.0）产品 
                                       --2)按信贷通知内容,老产品编号为：201020100024-饲料e贷-恒兴股份 更新为 新产品编号为：201020100064-好企贷（恒兴）
                                       --201020100014、201020100024、201020100051、201020100052新增互联贷款业务标签，参考201020100062 饲料e贷-海大集团
  *             96   20251209  LIP     出口代付的入账账号取国结登记的收款人账号
  *             97   20251217  LIP     加工福费廷还款的交易对手信息
  *             98   20251222  LIP     调整福费廷还款的还款账号信息
  *             99   20251225  YJY     一表通蔡佳俊反馈借据20130927111001的YBT_FLG默认为‘N’
  *            100   20251226  YJY     按照业务王玲的要求，在业务合同层里发生类型是“重组”的才抽取出来。重组方式“续期”金数归“01”续贷，“调整还款计划”归”03“其他
  *            101   20260104  YJY     修改零售信贷部分的贷款形式，按照最新码值映射
  *            102   20260106  YJY     新增202010100009富民联合贷消费、202020100002富民联合贷经营
  *            103   20260115  LIP     福费廷还款增加内部户转入借据时补录的交易对手信息
  *            104   20260119  YJY     修改PTY_PARTY_PHYS_ADDR_H这个表PHYS_ADDR_TYPE_CD字段的码值，调整为现在有效的码值映射 
  *            105   20260127  LYH     增加账户变更类别代码ACCT_MODIF_CATE_CD字段   
  *            106   20260203  YJY     修改零售部分的无还本续贷的取值，张家伟确认个人无还本续贷原本是按照发生类型为”原额度续作“进行判断，后续个人无还本续贷的判断逻辑需要改为按照信贷系统的“发生类型为无还本续贷”进行判断
  *            107   20260204  YJY     201020100014、201020100024、201020100051、201020100052新增互联贷款业务标签，参考201020100062 饲料e贷-海大集团
  *            108   20260213  LIP     实际终止日期、终止日期大于跑批日期时，将日期置空
  *            109   20260226  YJY     华兴好易贷（信用） 201010300040\华兴好易贷（经营-信用）201020100060判断是否线下核身为否的则为互联网
  *            110   20260309  LIP     增加判断对公信贷重组贷款的逻辑
  *            111   20260311  YJY     加工对公部分的贷款形式、重组贷款标识，报送的状态应以重组或续期后新合同的类型为准
  *            112   20260312  YJY     对公信贷部分新增字段：是否境外并购贷款、并购贷款类型、是否退役军人创办企业
  *            113   20260316  LIP     调整对公信贷部分的DSBR_MODE放款方式取数逻辑
  *            114   20260319  YJY     增加判断对公信贷重组贷款的逻辑，信贷系统未对重组类型-调整还款计划的合同进行改造
  *            115   20260324  YJY     票据贴现、票据转贴现部分新增实付金额字段
  *            116   20260413  YJY     1）一表通严希婧反馈：203050100002-微众对公联合贷的取联合贷额度信息表的LMT_RELA_APPL_ID--额度关联申请编号（行内授信编号），其他产品取LMT_CONT_ID--额度合同编号
                                       2）根据一表通6.27的F270010--贷款发放类型，调整零售部分的RCMM_LOAN_FLG字段，与REGROUP_LOAN_FLG逻辑保持一致
  *********************************************************************************************************/
AS
  --定义变量
  V_STEP             INTEGER := 0;               --处理步骤
  V_P_DATE           VARCHAR2(8);                --跑批数据日期
  V_STARTTIME        DATE;                       --处理开始时间
  V_ENDTIME          DATE;                       --处理结束时间
  V_SQLCOUNT         INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);              --SQL执行描述信息
  V_MONTH_START_DATE DATE;                       --系统时间对应月初日期
  V_YEAR_START_DATE  DATE;                       --系统时间对应年初日期  --ADD BY PSF 20250916
  V_STEP_DESC        VARCHAR2(200);              --任务名称
  V_PART_NAME        VARCHAR2(100);              --分区名
  V_TAB_NAME         VARCHAR2(100) := 'M_LOAN_IN_DUBILL_INFO'; --表名
  V_PROC_NAME        VARCHAR2(30) := 'ETL_M_LOAN_IN_DUBILL_INFO'; --程序名称
  V_SYSTEM           VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'MM');
  V_YEAR_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'YYYY'); --ADD BY PSF 20250916
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 处理首贷日标志 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00';
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
  --加工客户的首笔借据及首次放款日期
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00
    (CUST_ID
    ,RCPT_ID
    ,LOAN_ACT_DSTR_DT
    )
  WITH TMP1 AS (
    SELECT CUST_ID,DUBIL_ID AS RCPT_ID,CASE WHEN FIR_DISTR_DT = DATE '0001-01-01' THEN NULL ELSE FIR_DISTR_DT END AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.ADD_CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息静态表
     WHERE FIR_DISTR_DT <> DATE '0001-01-01'
       AND TRIM(CUST_ID) IS NOT NULL
     UNION ALL
    SELECT CUST_ID,DUBIL_NUM AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT CUST_ID,DUBIL_ID AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT CUST_ID,DUBIL_ID AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END  AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO_CLEAR
     UNION ALL
    SELECT CUST_ID,DUBIL_NUM AS RCPT_ID,CASE WHEN DISTR_DT = DATE '0001-01-01' THEN NULL ELSE DISTR_DT END AS LOAN_ACT_DSTR_DT
      FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  TMP2 AS (
    SELECT T.CUST_ID,T.RCPT_ID,TO_CHAR(T.LOAN_ACT_DSTR_DT,'YYYYMMDD') LOAN_ACT_DSTR_DT,
           ROW_NUMBER() OVER(PARTITION BY T.CUST_ID ORDER BY T.LOAN_ACT_DSTR_DT,T.RCPT_ID NULLS LAST) RN--20230130 XUXIAOBIN MODIFY
      FROM TMP1 T)
  SELECT T.CUST_ID,T.RCPT_ID,T.LOAN_ACT_DSTR_DT
    FROM TMP2 T
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总1 主账户 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02';
  COMMIT;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02
    ( CUST_ACCT_ID         --账户编号
      ,CUST_ACCT_NAME      --账户户名
      ,ACCT_BELONG_ORG_ID  --账户所属机构
      ,ORG_ID1             --账户所属机构映射报送机构
      ,FIN_INST_CODE       --银行机构代码
      ,FIN_LICS_NUM        --金融许可证号
      ,ORG_NAME            --银行机构名称
      ,COUNTY_CD           --机构地区
     )
  SELECT  A.CUST_ACCT_ID                             --账户编号
         ,A.CUST_ACCT_NAME                           --账户户名
         ,NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID)) AS ACCT_BELONG_ORG_ID --账户所属机构
         ,B.ORG_ID1                                  --账户所属机构映射报送机构
         ,B.FIN_INST_CODE                            --银行机构代码
         ,B.FIN_LICS_NUM                             --金融许可证号
         ,B.BKNAME                                   --银行机构名称
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A      --存款主账户信息
    LEFT JOIN RRP_MDL.ORG_CONFIG B                   --机构配置表
      ON B.ORG_ID = NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID))
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C    --内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230530 新一代账户编号和卡号分开，需单独拿卡号的数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总2 主账户 --';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02
    ( CUST_ACCT_ID        --账户编号
     ,CUST_ACCT_NAME      --账户户名
     ,ACCT_BELONG_ORG_ID  --账户所属机构
     ,ORG_ID1             --账户所属机构映射报送机构
     ,FIN_INST_CODE       --银行机构代码
     ,FIN_LICS_NUM        --金融许可证号
     ,ORG_NAME            --银行机构名称
     ,COUNTY_CD           --机构地区
     )
  SELECT  A.CUST_ACCT_CARD_NO                        --账户编号
         ,A.CUST_ACCT_NAME                           --账户户名
         ,NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID)) ACCT_BELONG_ORG_ID --账户所属机构
         ,B.ORG_ID1                                  --账户所属机构映射报送机构
         ,B.FIN_INST_CODE                            --银行机构代码
         ,B.FIN_LICS_NUM                             --金融许可证号
         ,B.BKNAME                                   --银行机构名称
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) COUNTY_CD --机构地区
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A      --存款主账户信息
    LEFT JOIN RRP_MDL.ORG_CONFIG B                   --机构配置表
      ON B.ORG_ID = NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID))
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C    --内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 D
      ON D.CUST_ACCT_ID = A.CUST_ACCT_CARD_NO
   WHERE D.CUST_ACCT_ID IS NULL
     AND TRIM(A.CUST_ACCT_CARD_NO) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总3 内部账户--';
  V_STARTTIME := SYSDATE;
  INSERT/*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02
    ( CUST_ACCT_ID        --账户编号
     ,CUST_ACCT_NAME      --账户户名
     ,ACCT_BELONG_ORG_ID  --账户所属机构
     ,ORG_ID1             --账户所属机构映射报送机构
     ,FIN_INST_CODE       --银行机构代码
     ,FIN_LICS_NUM        --金融许可证号
     ,ORG_NAME            --银行机构名称
     ,COUNTY_CD           --机构地区
     )
  SELECT  A.MAIN_ACCT_ID        AS CUST_ACCT_ID       --账户编号
         ,A.ACCT_NAME           AS CUST_ACCT_NAME     --账户户名
         ,TRIM(A.BELONG_ORG_ID) AS ACCT_BELONG_ORG_ID --账户所属机构
         ,B.ORG_ID1                                   --账户所属机构映射报送机构
         ,B.FIN_INST_CODE                             --银行机构代码
         ,B.FIN_LICS_NUM                              --金融许可证号
         ,B.BKNAME                                    --银行机构名称
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A            --内部账户
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 D
      ON D.CUST_ACCT_ID = A.MAIN_ACCT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG B                  --机构配置表
      ON B.ORG_ID = TRIM(A.BELONG_ORG_ID)
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C   --内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE D.CUST_ACCT_ID IS NULL
     AND TRIM(A.MAIN_ACCT_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 将主账户和内部户账户汇总4 银行卡信息--';
  V_STARTTIME := SYSDATE;
  INSERT/*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02
    ( CUST_ACCT_ID        --账户编号
     ,CUST_ACCT_NAME      --账户户名
     ,ACCT_BELONG_ORG_ID  --账户所属机构
     ,ORG_ID1             --账户所属机构映射报送机构
     ,FIN_INST_CODE       --银行机构代码
     ,FIN_LICS_NUM        --金融许可证号
     ,ORG_NAME            --银行机构名称
     ,COUNTY_CD            --机构地区
     )
  SELECT  A.CARD_NO               AS CUST_ACCT_ID        --账户编号
         ,A.CARD_NAME             AS CUST_ACCT_NAME      --账户户名
         ,TRIM(A.CARD_ISS_ORG_ID) AS ACCT_BELONG_ORG_ID  --账户所属机构
         ,B.ORG_ID1                                      --账户所属机构映射报送机构
         ,B.FIN_INST_CODE                                --银行机构代码
         ,B.FIN_LICS_NUM                                 --金融许可证号
         ,B.BKNAME                                       --银行机构名称
         ,COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) AS COUNTY_CD --机构地区
    FROM RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO A  --银行卡基本信息
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 D
      ON D.CUST_ACCT_ID = A.CARD_NO
    LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
      ON B.ORG_ID = TRIM(A.CARD_ISS_ORG_ID)
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息表
      ON C.ORG_ID = B.ORG_ID1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE D.CUST_ACCT_ID IS NULL
     AND TRIM(A.CARD_NAME) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '精准扶贫临时表数据处理-1';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP03');
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP03  --表内借据信息--精准扶贫按证件
    (CERT_NO     --01 证件号
    ,TPZT        --02 脱贫状态
    ,ACCT_DURAN  --03 扶贫名录期间
    ,QG_FLAG     --04 全国标志
    )
  SELECT P1.PKHSFZH         AS CERT_NO        --01证件号
        ,'已脱贫'           AS TPZT           --02 脱贫状态
        ,'2021-04'          AS ACCT_DURAN     --03扶贫名录期间
        ,'1'                AS QG_FLAG        --04 全国标志
    FROM RRP_MDL.ADD_JZFP_LIST_CN_202104 P1 --精准扶贫全国名录  发放日为20210401 之后按此名录为准
   WHERE P1.TPZT = '脱贫'  --202104名单全部是脱贫，默认已脱贫
   GROUP BY P1.PKHSFZH;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP04');
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP04 --表内借据信息--精准扶贫按客户
    (CUST_ID      --01 客户号
    ,CERT_NO      --02 证件号
    ,TPZT         --03 脱贫状态
    ,ACCT_DURAN   --04 扶贫名录期间
    )
  SELECT P1.CUST_ID      --01 客户号
        ,P1.CERT_NO      --02 证件号
        ,P2.TPZT         --03 脱贫状态
        ,P2.ACCT_DURAN   --04 扶贫名录期间
    FROM RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO P1 --个人客户基本信息表
   INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP03 P2
      ON P1.CERT_NO = P2.CERT_NO
   WHERE P1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230828 票据垫款的入账账号取持票人账号，取不到或账号为0空时，取出票人账号
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据表垫款入账账号临时表处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP06';
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP06
    ( DUBIL_ID                       --借据号
     ,STD_PROD_ID                    --产品编号
     ,PAYOFF_DT                      --结清日期
     ,RELA_DUBIL_ID                  --原借据号
     ,BILL_ID                        --票据编号
     ,BILL_NUM                       --票据号码
     ,SETTLEDATE                     --解付日期
     ,ETR_ACC                        --入账账号
     ,ETR_ACC_NM                     --入账户名
     ,LOAN_ETR_ACC_OPEN_BANK_NM       --入账账号所属行名
     )
    WITH DK_LOAN_DUBIL_INFO AS (
  SELECT A.DUBIL_ID,A.STD_PROD_ID,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') PAYOFF_DT,B.DUBIL_ID RELA_DUBIL_ID,B.BILL_ID,B.BILL_NUM
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B
      ON B.DUBIL_ID = A.RELA_DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.STD_PROD_ID = '203040100001' --银承垫款
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    BILL_INFO AS (
  SELECT TA.BILL_ID,TA.BILL_NUM,TA.BILL_SUB_INTRV_ID,TA.DRAWER_ACCT_NUM,TA.DRAWER_NAME,TA.DRAWER_OPEN_BANK_NAME
    FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO TA
   WHERE TA.BILL_TYPE_CD = 'AC01'
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY TA.BILL_ID,TA.BILL_NUM,TA.BILL_SUB_INTRV_ID,TA.DRAWER_ACCT_NUM,TA.DRAWER_NAME,TA.DRAWER_OPEN_BANK_NAME
   UNION
  SELECT TA.BILL_ID,TA.BILL_NUM,'-' BILL_SUB_INTRV_ID,TA.DRAWER_ACCT_NUM,TA.DRAWER_NAME,TA.DRAWER_OPEN_BANK_NAME
    FROM RRP_MDL.ADD_AGT_BILL_INFO_HIS TA
   WHERE BILL_TYPE_CD = 'AC01'
   GROUP BY TA.BILL_ID,TA.BILL_NUM,TA.DRAWER_ACCT_NUM,TA.DRAWER_NAME,TA.DRAWER_OPEN_BANK_NAME),
   BILL_INFO_JF AS (
  SELECT TA.BILL_ID,TA.BILL_NUM,TA.BILL_SUB_INTRV_ID,TA.DRAWER_ACCT_NUM,TA.DRAWER_NAME,TA.DRAWER_OPEN_BANK_NAME,
         TB.RECVER_ACCT_NUM,TB.SUGST_PAYER_NAME,TB.SUGST_PAYER_OPEN_BANK_NUM,TO_CHAR(TB.APPL_DT,'YYYYMMDD') APPL_DT,
         TC.SUGST_PAYER_ACCT_ID CASH_SUGST_PAYER_ACCT_ID,TC.SUGST_PAYER_NAME CASH_SUGST_PAYER_NAME,
         TC.SUGST_PAYER_OPEN_BANK_NO CASH_SUGST_PAYER_OPEN_BANK_NO,TO_CHAR(TC.SUGST_PAY_APPL_DT,'YYYYMMDD') SUGST_PAY_APPL_DT,
         TD.RECVER_TRUST_ACCT_NUM,TD.RECVER_TRUST_ACCT_NAME,TD.RECVER_ORG_CD,TO_CHAR(TD.STL_TM,'YYYYMMDD') STL_DT,
         CASE WHEN TB.RECVER_ACCT_NUM NOT IN ('0',' ','-') THEN TB.RECVER_ACCT_NUM
              WHEN TC.SUGST_PAYER_ACCT_ID NOT IN ('0',' ','-') THEN TC.SUGST_PAYER_ACCT_ID
              WHEN TD.RECVER_TRUST_ACCT_NUM NOT IN ('0',' ','-') AND TD.RECVER_TRUST_ACCT_NUM <> TB.RECVER_ACCT_NUM THEN TD.RECVER_TRUST_ACCT_NUM
              WHEN TA.DRAWER_ACCT_NUM NOT IN ('0',' ','-') THEN TA.DRAWER_ACCT_NUM --否则取出票人信息
          END ZJ_RECVER_ACCT_NUM,
         CASE WHEN TB.RECVER_ACCT_NUM NOT IN ('0',' ','-') THEN TB.SUGST_PAYER_NAME
              WHEN TC.SUGST_PAYER_ACCT_ID NOT IN ('0',' ','-') THEN TC.SUGST_PAYER_NAME
              WHEN TD.RECVER_TRUST_ACCT_NUM NOT IN ('0',' ','-') AND TD.RECVER_TRUST_ACCT_NUM <> TB.RECVER_ACCT_NUM THEN TD.RECVER_TRUST_ACCT_NAME
              WHEN TA.DRAWER_ACCT_NUM NOT IN ('0',' ','-') THEN TA.DRAWER_NAME --否则取出票人信息
          END ZJ_DRAWER_NAME,
         CASE WHEN TB.RECVER_ACCT_NUM NOT IN ('0',' ','-') THEN TB.SUGST_PAYER_OPEN_BANK_NUM
              WHEN TC.SUGST_PAYER_ACCT_ID NOT IN ('0',' ','-') THEN TC.SUGST_PAYER_OPEN_BANK_NO
              WHEN TD.RECVER_TRUST_ACCT_NUM NOT IN ('0',' ','-') AND TD.RECVER_TRUST_ACCT_NUM <> TB.RECVER_ACCT_NUM THEN TD.RECVER_ORG_CD
              WHEN TA.DRAWER_ACCT_NUM NOT IN ('0',' ','-') THEN TA.DRAWER_OPEN_BANK_NAME --否则取出票人信息
          END ZJ_SUGST_PAYER_OPEN_BANK_NUM,
         ROW_NUMBER() OVER(PARTITION BY TA.BILL_NUM ORDER BY
                 LEAST(CASE WHEN TO_CHAR(TB.APPL_DT,'YYYYMMDD') NOT IN ('00010101') THEN TB.APPL_DT END,
                       CASE WHEN TO_CHAR(TC.SUGST_PAY_APPL_DT,'YYYYMMDD') NOT IN ('00010101') THEN TC.SUGST_PAY_APPL_DT END,
                       CASE WHEN TO_CHAR(TD.STL_TM,'YYYYMMDD') NOT IN ('00010101') THEN TD.STL_TM END) NULLS LAST,
                 CASE WHEN TB.RECVER_ACCT_NUM NOT IN ('0',' ','-') THEN '1'
                      WHEN TC.SUGST_PAYER_ACCT_ID NOT IN ('0',' ','-') THEN '2'
                      WHEN TC.SUGST_PAYER_ACCT_ID NOT IN ('0',' ','-') THEN '3' END NULLS LAST,
                TA.BILL_ID DESC) RN
    FROM BILL_INFO TA
    LEFT JOIN RRP_MDL.O_IML_EVT_SUGST_PAY_APPL_EVT TB
      ON TB.BILL_ID = TA.BILL_ID
     AND TB.APPL_TRAN_TYPE_CD = '02' --业务标志： 01 申请 02 签收
     AND TB.CLEAR_REST_CD = 'MS04' --结算成功
     AND TB.ENTRY_STATUS_CD = '03' --记账成功
    LEFT JOIN RRP_MDL.O_IML_AGT_BA_EXP_CASH_APPL_H TC
      ON TC.BILL_ID = TA.BILL_ID
     AND TC.ENTRY_STATUS_CD = '03' --记账成功
     AND TC.ID_MARK <> 'D'
     AND TC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_BILL_BUS_STL_INFO TD
      ON TD.BILL_NUM = TA.BILL_NUM
     AND TD.BILL_SUB_INTRV_ID = TA.BILL_SUB_INTRV_ID
     AND TD.STL_BUS_TYPE_CD = 'RE2011'
     AND TD.ID_MARK <> 'D'
     AND TD.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TD.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  TB.DUBIL_ID
         ,TB.STD_PROD_ID
         ,TB.PAYOFF_DT
         ,TB.RELA_DUBIL_ID
         ,TB.BILL_ID
         ,T.BILL_NUM
         ,CASE WHEN T.APPL_DT NOT IN ('00010101') THEN T.APPL_DT
               WHEN T.SUGST_PAY_APPL_DT NOT IN ('00010101') THEN T.SUGST_PAY_APPL_DT
               WHEN T.STL_DT NOT IN ('00010101') THEN T.STL_DT
           END                 AS SETTLEDATE
         ,T.ZJ_RECVER_ACCT_NUM AS ETR_ACC
         ,T.ZJ_DRAWER_NAME     AS ETR_ACC_NM
         ,CASE WHEN TA.SYS_PRTCPTR_BIGAMT_BANK_NAME_A IS NOT NULL THEN TA.SYS_PRTCPTR_BIGAMT_BANK_NAME_A
               WHEN TC.SYS_PRTCPTR_BIGAMT_BANK_NAME_A IS NOT NULL THEN TC.SYS_PRTCPTR_BIGAMT_BANK_NAME_A
               ELSE T.ZJ_SUGST_PAYER_OPEN_BANK_NUM
           END LOAN_ETR_ACC_OPEN_BANK_NM
    FROM DK_LOAN_DUBIL_INFO TB
    LEFT JOIN BILL_INFO_JF T
      ON T.BILL_NUM = TB.BILL_NUM
     AND T.RN = 1
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM TA
      ON TA.SYS_PRTCPTR_BIGAMT_BANK_NO = T.ZJ_SUGST_PAYER_OPEN_BANK_NUM
     AND TA.RANK = 1
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM TC
      ON TC.MEM_ORG_CD = T.ZJ_SUGST_PAYER_OPEN_BANK_NUM
     AND TC.ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY 20240204 加工福费廷的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据表二级福费廷入账账号临时表处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP06
    ( DUBIL_ID                       --借据号
     ,STD_PROD_ID                    --产品编号
     ,PAYOFF_DT                      --结清日期
     ,RELA_DUBIL_ID                  --原借据号
     ,BILL_ID                        --票据编号
     ,BILL_NUM                       --票据号码
     ,SETTLEDATE                     --解付日期
     ,ETR_ACC                        --入账账号
     ,ETR_ACC_NM                     --入账户名
     ,LOAN_ETR_ACC_OPEN_BANK_NM      --入账账号所属行名
     )
  SELECT  TA.DUBIL_ID                             AS DUBIL_ID                 --借据号
         ,TA.STD_PROD_ID                          AS STD_PROD_ID              --产品编号
         --,TA.PAYOFF_DT                            AS PAYOFF_DT                --结清日期
         ,TO_CHAR(TA.PAYOFF_DT,'YYYYMMDD')        AS PAYOFF_DT                --结清日期
         ,TA.RELA_DUBIL_ID                        AS RELA_DUBIL_ID            --原借据号
         ,NULL                                    AS BILL_ID                  --票据编号
         ,NULL                                    AS BILL_NUM                 --票据号码
         ,NULL                                    AS SETTLEDATE               --解付日期
         ,TRIM(T.CNTPTY_RECVBL_ACCT_ID)           AS ETR_ACC                  --入账账号
         ,TRIM(T.CNTPTY_RECVBL_ACCT_NAME)         AS ETR_ACC_NM               --入账户名
         ,TRIM(T.CNTPTY_RECVBL_BANK_NAME)         AS LOAN_ETR_ACC_OPEN_BANK_NM --入账账号所属行名
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H T
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TA
      ON TA.OUT_ACCT_FLOW_NUM = T.OUT_ACCT_FLOW_NUM
     AND TA.STD_PROD_ID IN ('203020300002','203030600002','203030200001','203030600001', --二级福费廷 --MOD BY LIP 20241021 203030200001-国内信用证项下议付、203030600001-国内信用证项下福费廷产品的交易对手取数口径调整
                            '203030500001','203030500014','203030500015') --MOD BY LIP 20250613 增加保理的入账账号取数口径
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(T.CNTPTY_RECVBL_ACCT_ID) IS NOT NULL
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY 20240204 加工一级福费廷出账的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据表一级福费廷出账入账账号临时表处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP06
    (DUBIL_ID                       --借据号
    ,STD_PROD_ID                    --产品编号
    ,PAYOFF_DT                      --结清日期
    ,RELA_DUBIL_ID                  --原借据号
    ,BILL_ID                        --票据编号
    ,BILL_NUM                       --票据号码
    ,SETTLEDATE                     --解付日期
    ,ETR_ACC                        --入账账号
    ,ETR_ACC_NM                     --入账户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM      --入账账号所属行名
    )
  SELECT  TA.DUBIL_ID                             AS DUBIL_ID                 --借据号
         ,TA.STD_PROD_ID                          AS STD_PROD_ID              --产品编号
         --,TA.PAYOFF_DT                            AS PAYOFF_DT                --结清日期
         ,TO_CHAR(TA.PAYOFF_DT,'YYYYMMDD')        AS PAYOFF_DT                --结清日期
         ,TA.RELA_DUBIL_ID                        AS RELA_DUBIL_ID            --原借据号
         ,NULL                                    AS BILL_ID                  --票据编号
         ,NULL                                    AS BILL_NUM                 --票据号码
         ,NULL                                    AS SETTLEDATE               --解付日期
         ,TRIM(T.LEVEL1_FFT_ACTL_ENTER_ID)        AS ETR_ACC                  --入账账号
         ,TRIM(TB.CUST_ACCT_NAME)                 AS ETR_ACC_NM               --入账户名
         ,TRIM(TB.ORG_NAME)                       AS LOAN_ETR_ACC_OPEN_BANK_NM --入账账号所属行名
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H T
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TA
      ON TA.OUT_ACCT_FLOW_NUM = T.OUT_ACCT_FLOW_NUM
     AND (TA.STD_PROD_ID IN ('203020300001')--国际信用证项下福费廷 一级福费廷
          OR (TA.STD_PROD_ID IN ('203030600001') AND TRIM(T.CNTPTY_RECVBL_ACCT_ID) IS NULL)) --国内信用证项下福费廷
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 TB
      ON TB.CUST_ACCT_ID = TRIM(T.LEVEL1_FFT_ACTL_ENTER_ID)
   WHERE TRIM(T.LEVEL1_FFT_ACTL_ENTER_ID) IS NOT NULL
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251209 加工出口代付出账的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据表出口代付入账账号临时表处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP06
    (DUBIL_ID                       --借据号
    ,STD_PROD_ID                    --产品编号
    ,PAYOFF_DT                      --结清日期
    ,RELA_DUBIL_ID                  --原借据号
    ,BILL_ID                        --票据编号
    ,BILL_NUM                       --票据号码
    ,SETTLEDATE                     --解付日期
    ,ETR_ACC                        --入账账号
    ,ETR_ACC_NM                     --入账户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM      --入账账号所属行名
    )
  SELECT  T.DUBIL_NUM                             AS DUBIL_ID                 --借据号
         ,T.STD_PROD_ID                           AS STD_PROD_ID              --产品编号
         --,T.CLOS_ACCT_DT                          AS PAYOFF_DT                --结清日期
         ,TO_CHAR(T.CLOS_ACCT_DT,'YYYYMMDD')      AS PAYOFF_DT                --结清日期
         ,NULL                                    AS RELA_DUBIL_ID            --原借据号
         ,NULL                                    AS BILL_ID                  --票据编号
         ,NULL                                    AS BILL_NUM                 --票据号码
         ,NULL                                    AS SETTLEDATE               --解付日期
         ,TRIM(TA.FINACT)                         AS ETR_ACC                  --入账账号
         ,TRIM(TB.CUST_ACCT_NAME)                 AS ETR_ACC_NM               --入账户名
         ,TRIM(TB.ORG_NAME)                       AS LOAN_ETR_ACC_OPEN_BANK_NM --入账账号所属行名
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T
   INNER JOIN RRP_MDL.O_IOL_ISBS_TRD TA
      ON TA.FINCOD = T.DUBIL_NUM
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 TB
      ON TB.CUST_ACCT_ID = TRIM(TA.FINACT)
   WHERE TRIM(TA.FINACT) IS NOT NULL
     AND T.STD_PROD_ID IN ('203020700002')--出口代付
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251217 加工福费廷还款的交易对手信息
  --MOD BY LIP 20260115 根据沟通，内部户转入借据的流水中也有补录真实交易对手，补充这部分的来源
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据表福费廷还款账号临时表处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE M_LOAN_IN_DUBILL_INFO_TEMP08';
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP08
    (DUBIL_NUM               --借据号
    ,STD_PROD_ID             --标准产品编号
    ,TRAN_DT                 --借据还款交易日期
    ,TRAN_REF_NO             --借据还款流水号
    ,NCBS_REFERENCE          --转入内部户流水号
    ,CHANNEL_SEQ_NO          --转入内部户全局流水号
    ,OTH_REAL_BASE_ACCT_NO   --转入内部户账号
    ,OTH_REAL_TRAN_NAME      --转入内部户账号户名
    ,CONTRA_BANK_CODE        --转入内部户账号行号
    ,DFXH                    --转入内部户账号人行支付行号
    ,CONTRA_BANK_NAME        --转入内部户账号行名
    ,TRAN_AMT                --转入内部户金额
    ,NBHZR_TRAN_AMT          --转入内部户总金额
    ,HKJE                    --福费廷还款金额
    ,RM                      --序号
    )
    WITH REP_DUBIL_INFO AS (
  SELECT /*+MATERIALIZE*/
         T1.DUBIL_NUM          AS DUBIL_NUM,
         SUM(T.TRAN_AMT)       AS TRAN_AMT,
         MAX(T.TRAN_REF_NO)    AS TRAN_REF_NO,
         MAX(TRUNC(T.TRAN_DT)) AS TRAN_DT,
         MAX(T1.STD_PROD_ID)   AS STD_PROD_ID
    FROM RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW T --贷款金融交易流水
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T1
      ON T1.ACCT_ID = T.ACCT_ID
     AND T1.STD_PROD_ID IN ('203030600001','203020300001','203030600002','203020300002') --福费廷
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.MAIN_EVT_CLS_CD = 'REC' --还款流水
     AND T.TRAN_CD NOT IN ('WAV') --不是豁免的
     AND T.CHN_ID = '100001' --柜面交易
     AND T.TRAN_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
     AND T.ETL_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')
   GROUP BY T1.DUBIL_NUM),
  NBHZCLS AS (--内部户转出流水的交易对手信息 --ADD BY LIP 20260115
  SELECT /*+MATERIALIZE*/
         T3.DUBIL_NUM                                     AS DUBIL_NUM               --借据号
        ,T3.STD_PROD_ID                                   AS STD_PROD_ID             --标准产品编号
        ,TO_CHAR(T3.TRAN_DT,'YYYYMMDD')                   AS TRAN_DT                 --借据还款交易日期
        ,T1.REFERENCE                                     AS TRAN_REF_NO             --借据还款流水号
        ,NULL                                             AS NCBS_REFERENCE          --转入内部户流水号
        ,NULL                                             AS CHANNEL_SEQ_NO          --转入内部户全局流水号
        ,T1.OTH_REAL_BASE_ACCT_NO                         AS OTH_REAL_BASE_ACCT_NO   --转入内部户账号
        ,T1.OTH_REAL_TRAN_NAME                            AS OTH_REAL_TRAN_NAME      --转入内部户账号户名
        ,T1.CONTRA_BANK_CODE                              AS CONTRA_BANK_CODE        --转入内部户账号行号
        ,COALESCE(T4.FIN_INST_CODE,T1.CONTRA_BANK_CODE)   AS DFXH                    --转入内部户账号人行支付行号
        --,COALESCE(TRIM(T4.ORG_NAME),TRIM(T5.BKNAME))      AS CONTRA_BANK_NAME        --转入内部户账号行名
        ,COALESCE(TRIM(T1.CONTRA_BANK_NAME),TRIM(T4.ORG_NAME),TRIM(T5.BKNAME)) AS CONTRA_BANK_NAME --转入内部户账号行名 --MOD BY LIP 20260417
        ,T1.TRAN_AMT                                      AS TRAN_AMT                --转入内部户金额
        ,SUM(T1.TRAN_AMT) OVER(PARTITION BY T3.DUBIL_NUM) AS NBHZR_TRAN_AMT          --转入内部户总金额
        ,T3.TRAN_AMT                                      AS HKJE                    --福费廷还款金额
        ,ROW_NUMBER() OVER(PARTITION BY T3.DUBIL_NUM ORDER BY T1.TRAN_AMT DESC) AS RM --序号
    FROM RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG T1 --真实交易对手登记簿
   INNER JOIN REP_DUBIL_INFO T3
      ON T3.TRAN_REF_NO = T1.REFERENCE
     AND T3.DUBIL_NUM <> T1.OTH_REAL_BASE_ACCT_NO
     AND T3.TRAN_DT = TO_DATE(SUBSTR(TRIM(T1.TRAN_TIMESTAMP),1,10),'YYYY-MM-DD')
    LEFT JOIN RRP_MDL.ORG_CONFIG T4
      ON T4.ORG_ID = TRIM(T1.CONTRA_BANK_CODE)
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T5
      ON T5.BKCD = TRIM(T1.CONTRA_BANK_CODE)
     AND T5.ID_MARK <> 'D'
     AND T5.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T5.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
   NBHZRLS AS (--内部户转入流水的交易对手登记信息，其中如果转出流水中已经补录了真实交易对手，以转出流水补录的交易对手为准
  SELECT /*+MATERIALIZE*/
         T3.DUBIL_NUM                                     AS DUBIL_NUM               --借据号
        ,T3.STD_PROD_ID                                   AS STD_PROD_ID             --标准产品编号
        ,TO_CHAR(T3.TRAN_DT,'YYYYMMDD')                   AS TRAN_DT                 --借据还款交易日期
        ,T3.TRAN_REF_NO                                   AS TRAN_REF_NO             --借据还款流水号
        ,T2.REFERENCE                                     AS NCBS_REFERENCE          --转入内部户流水号
        ,T2.CHANNEL_SEQ_NO                                AS CHANNEL_SEQ_NO          --转入内部户全局流水号
        ,T2.OTH_REAL_BASE_ACCT_NO                         AS OTH_REAL_BASE_ACCT_NO   --转入内部户账号
        ,T2.OTH_REAL_TRAN_NAME                            AS OTH_REAL_TRAN_NAME      --转入内部户账号户名
        ,T2.CONTRA_BANK_CODE                              AS CONTRA_BANK_CODE        --转入内部户账号行号
        ,COALESCE(T4.FIN_INST_CODE,T2.CONTRA_BANK_CODE)   AS DFXH                    --转入内部户账号人行支付行号
        ,COALESCE(TRIM(T4.ORG_NAME),TRIM(T5.BKNAME))      AS CONTRA_BANK_NAME        --转入内部户账号行名
        ,T2.TRAN_AMT                                      AS TRAN_AMT                --转入内部户金额
        ,SUM(T2.TRAN_AMT) OVER(PARTITION BY T3.DUBIL_NUM) AS NBHZR_TRAN_AMT          --转入内部户总金额
        ,T3.TRAN_AMT                                      AS HKJE                    --福费廷还款金额
        ,ROW_NUMBER() OVER(PARTITION BY T3.DUBIL_NUM ORDER BY T2.TRAN_AMT DESC) AS RM --序号
    FROM RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG T1 --真实交易对手登记簿
   INNER JOIN RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG T2 --真实交易对手登记簿
      ON T2.REFERENCE = T1.REFERENCE
     AND T2.CHANNEL_SEQ_NO = T1.CHANNEL_SEQ_NO
     AND T2.SUB_SEQ_NO = T1.SUB_SEQ_NO
     AND T2.OTH_REAL_BASE_ACCT_NO <> T1.OTH_REAL_BASE_ACCT_NO --交易对手不是借据号的那笔流水
     AND TRIM(T2.OTH_REAL_BASE_ACCT_NO) IS NOT NULL
     AND T2.ID_MARK <> 'D'
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN REP_DUBIL_INFO T3
      ON T3.DUBIL_NUM = T1.OTH_REAL_BASE_ACCT_NO
     AND T3.TRAN_DT = TO_DATE(SUBSTR(TRIM(T1.TRAN_TIMESTAMP),1,10),'YYYY-MM-DD')
    LEFT JOIN RRP_MDL.ORG_CONFIG T4
      ON T4.ORG_ID = TRIM(T2.CONTRA_BANK_CODE)
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T5
      ON T5.BKCD = TRIM(T2.CONTRA_BANK_CODE)
     AND T5.ID_MARK <> 'D'
     AND T5.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T5.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN NBHZCLS T6 --转出流水中已经补录了真实交易对手，以转出流水补录的交易对手为准
      ON T6.DUBIL_NUM = T3.DUBIL_NUM
   WHERE T6.DUBIL_NUM IS NULL
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
   SELECT DUBIL_NUM               --借据号
         ,STD_PROD_ID             --标准产品编号
         ,TRAN_DT                 --借据还款交易日期
         ,TRAN_REF_NO             --借据还款流水号
         ,NCBS_REFERENCE          --转入内部户流水号
         ,CHANNEL_SEQ_NO          --转入内部户全局流水号
         ,OTH_REAL_BASE_ACCT_NO   --转入内部户账号
         ,OTH_REAL_TRAN_NAME      --转入内部户账号户名
         ,CONTRA_BANK_CODE        --转入内部户账号行号
         ,DFXH                    --转入内部户账号人行支付行号
         ,CONTRA_BANK_NAME        --转入内部户账号行名
         ,TRAN_AMT                --转入内部户金额
         ,NBHZR_TRAN_AMT          --转入内部户总金额
         ,HKJE                    --福费廷还款金额
         ,RM                      --序号
     FROM NBHZCLS
    UNION ALL
   SELECT DUBIL_NUM               --借据号
         ,STD_PROD_ID             --标准产品编号
         ,TRAN_DT                 --借据还款交易日期
         ,TRAN_REF_NO             --借据还款流水号
         ,NCBS_REFERENCE          --转入内部户流水号
         ,CHANNEL_SEQ_NO          --转入内部户全局流水号
         ,OTH_REAL_BASE_ACCT_NO   --转入内部户账号
         ,OTH_REAL_TRAN_NAME      --转入内部户账号户名
         ,CONTRA_BANK_CODE        --转入内部户账号行号
         ,DFXH                    --转入内部户账号人行支付行号
         ,CONTRA_BANK_NAME        --转入内部户账号行名
         ,TRAN_AMT                --转入内部户金额
         ,NBHZR_TRAN_AMT          --转入内部户总金额
         ,HKJE                    --福费廷还款金额
         ,RM                      --序号
     FROM NBHZRLS;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*--ADD BY 20240204 加工一二级福费廷转让的交易对手信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据表一二级福费廷转让入账账号临时表处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP06
    (DUBIL_ID,                       --借据号
     STD_PROD_ID,                    --产品编号
     PAYOFF_DT,                      --结清日期
     RELA_DUBIL_ID,                  --原借据号
     BILL_ID,                        --票据编号
     BILL_NUM,                       --票据号码
     SETTLEDATE,                     --解付日期
     ETR_ACC,                        --入账账号
     ETR_ACC_NM,                     --入账户名
     LOAN_ETR_ACC_OPEN_BANK_NM       --入账账号所属行名
     )
  SELECT TB.DUBIL_ID                             AS DUBIL_ID,                 --借据号
         TD.STD_PROD_ID                          AS STD_PROD_ID,              --产品编号
         TD.PAYOFF_DT                            AS PAYOFF_DT,                --结清日期
         TRIM(TD.RELA_DUBIL_ID)                  AS RELA_DUBIL_ID,            --原借据号
         NULL                                    AS BILL_ID,                  --票据编号
         NULL                                    AS BILL_NUM,                 --票据号码
         NULL                                    AS SETTLEDATE,               --解付日期
         TRIM(TA.CAP_SRC_ACCT_ID)                AS ETR_ACC,                  --入账账号
         TRIM(TA.CAP_SRC_ACCT_NAME)              AS ETR_ACC_NM,               --入账户名
         TRIM(TC.BKNAME)                         AS LOAN_ETR_ACC_OPEN_BANK_NM --入账账号所属行名
    FROM RRP_MDL.O_IOL_ICMS_ACCT_TRANSACTION T
   INNER JOIN RRP_MDL.O_IML_AGT_FFT_TRAN_TOT_TAB TA
      ON TA.FLOW_NUM = T.DOCUMENTNO
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_AGT_FFT_TRAN_DTL TB
      ON TB.FLOW_NUM = TA.FLOW_NUM
     AND TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO TC
      ON TC.BKCD = TA.CAP_SRC_BANK_NO
     AND TC.ID_MARK <> 'D'
     AND TC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO TD
      ON TD.DUBIL_ID = TB.DUBIL_ID
     AND TD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.DOCUMENTTYPE = 'jbo.acct.ACCT_TRANS_FFT'
     AND T.TRANSCODE = '2003'
     AND T.TRANSSTATUS = 'Finished'
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/
 
  --ADD BY YJY 20251104 加工联合网贷还款计划临时表
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 联合网贷还款计划临时表--';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_DUBILL_UNITE_WL_REPAY_PLAN_TMP';
  COMMIT;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_DUBILL_UNITE_WL_REPAY_PLAN_TMP
    ( DUBIL_ID       --借据编号
     ,PROD_ID        --产品编号
     ,TOT_PERDS      --原始总期数
     ,REPAY_PERDS    --原始还款期数
     ,CURR_PERDS     --当前期数
     ,WLD_CURR_PERDS --微粒贷当前期数
     ,LXQKQS         --连续欠款期数
     ,LJQKQS         --累计欠款期数
     )
  WITH UNITE_WL_REPAY_PLAN AS 
     ( SELECT  A.DUBIL_ID
              ,A.INIT_TOT_PERDS   AS TOT_PERDS
              ,A.INIT_REPAY_PERDS AS REPAY_PERDS
              ,A.REPAYBL_DT
              ,MAX(A.INIT_VALUE_DT) AS VALUE_DT
              ,A.ETL_DT
              ,A.PROD_ID
              --MOD BY 20240105 当产品是微粒贷，且逾期标志为否，但是超过了到期日期，EAST算逾期
              ,SUM(CASE WHEN (A.OVDUE_FLG = '1'                       
                              OR (A.PROD_ID IN ('202010100006','202010100008','202020100003')
                                  AND A.OVDUE_FLG = '0' 
                                  AND A.REPAY_FLG = '0'
                                  AND A.REPAYBL_DT IS NOT NULL 
                                  AND A.REPAYBL_DT <> TO_DATE('00010101','YYYYMMDD')
                                  AND A.REPAYBL_DT < TO_DATE(V_P_DATE,'YYYYMMDD') - 1))
                         AND A.REPAY_PERDS <> 0 
                        THEN 1 ELSE 0 END) AS OVDUE_FLG   --逾期标志为是 0为否                                                                                                                                                          
              ,MIN(CASE WHEN A.REPAY_FLG = '0' AND A.REPAY_PERDS <> 0 THEN 0 ELSE 1 END) AS REPAY_FLG --未偿还
         FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_PLAN A --联合网贷还款计划
        WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY A.DUBIL_ID,A.INIT_TOT_PERDS,A.INIT_REPAY_PERDS,A.REPAYBL_DT,A.ETL_DT,A.PROD_ID  )
   --普通联合网贷产品加工,剔除分期乐、微业贷3.0（好企贷-数据贷）        
   SELECT  N.DUBIL_ID
          ,N.PROD_ID
          ,MAX(N.TOT_PERDS)   AS TOT_PERDS   --总期数
          ,MAX(N.REPAY_PERDS) AS REPAY_PERDS --还款期数
           --MOD BY LIP 20230614 修改当前期数的取数口径
          ,MAX(CASE WHEN N.VALUE_DT >= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0 ELSE N.REPAY_PERDS END) AS CURR_PERDS --当前期数
           --MOD BY LIP 20240104 微粒贷的当前期数按照采集日期的下一期来取数
          ,MIN(CASE WHEN N.PROD_ID IN ('202010100006','202010100008','202020100003')
                     AND REPAYBL_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
                    THEN N.REPAY_PERDS 
                    ELSE N.TOT_PERDS END)   AS WLD_CURR_PERDS  --微粒贷当前期数
          ,SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                     AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
                     AND N.REPAY_FLG = 0 --未偿还
                    THEN 1 ELSE 0 END)      AS LXQKQS       --连续欠款期数
          ,SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                     AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --未偿还
                    THEN 1 ELSE 0 END)      AS LJQKQS       --累计欠款期数
      FROM UNITE_WL_REPAY_PLAN N --联合网贷还款计划
     WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND N.PROD_ID NOT IN ('202010200011','202010200010','201020100063') 
     GROUP BY N.DUBIL_ID,N.PROD_ID
     UNION ALL
    --分期乐、微业贷3.0（好企贷-数据贷）产品加工
    SELECT N.DUBIL_ID
          ,N.PROD_ID
          ,MAX(N.TOT_PERDS)   AS TOT_PERDS   --总期数
          ,MAX(N.REPAY_PERDS) AS REPAY_PERDS --还款期数
          ,MAX(CASE WHEN N.VALUE_DT >= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0 ELSE N.REPAY_PERDS END) AS CURR_PERDS --当前期数
          ,MIN(N.TOT_PERDS)   AS WLD_CURR_PERDS  --微粒贷当前期数
          ,SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                     AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                     AND N.REPAY_FLG = 0 --未偿还
                    THEN 1 ELSE 0 END)      AS LXQKQS       --连续欠款期数
          ,SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                     AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --未偿还
                    THEN 1 ELSE 0 END)      AS LJQKQS       --累计欠款期数
      FROM UNITE_WL_REPAY_PLAN N --联合网贷还款计划
     WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND N.PROD_ID IN ('202010200011','202010200010','201020100063') 
     GROUP BY N.DUBIL_ID,N.PROD_ID ; 

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--对公信贷部分';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP');
  INSERT/*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ACC_ID                      --账户编号
    ,RCPT_ID                     --借据编号
    ,CONT_ID                     --合同编号
    ,BILL_NO                     --票据号码
    ,COOP_AGRT_ID                --合作协议编号
    ,CUST_ID                     --客户编号
    ,ORG_ID                      --机构编号
    ,SUBJ_ID                     --科目编号
    ,LOAN_STD_PROD_ID            --贷款标准产品编号
    ,LOAN_STD_PROD_NM            --贷款标准产品名称
    ,LOAN_PROD_ID                --贷款产品编号
    ,LOAN_PROD_NM                --贷款产品名称
    ,LOAN_BIZ_TYP                --贷款业务类型
    ,CUR                         --币种
    ,LOAN_AMT                    --借款金额
    ,LOAN_BAL                    --贷款余额
    ,INT_ADJ                     --利息调整
    ,FAIR_VAL_CHG                --公允价值变动
    ,OVD_PRIN_BAL                --逾期本金余额
    ,IN_INT_OVD_BAL              --表内欠息余额
    ,OUT_INT_OVD_BAL             --表外欠息余额
    ,LOAN_ACT_DSTR_DT            --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT            --贷款原始到期日期
    ,LOAN_ACT_EXP_DT             --贷款实际到期日期
    ,ACT_END_DT                  --实际终止日期
    ,LAST_REPY_DT                --上次还款日期
    ,LAST_REPY_AMT               --上次还款金额
    ,VAL_DT                      --起息日期
    ,OPEN_ACC_DT                 --开户日期
    ,CNL_ACC_DT                  --销户日期
    ,PRIN_OVD_DT                 --本金逾期日期
    ,INT_OVD_DT                  --利息逾期日期
    ,OVD_DAYS                    --逾期天数
    ,OVD_TYP                     --逾期类型
    ,LOAN_USEAGE                 --贷款用途
    ,LVL5_CL                     --五级分类
    ,GUA_MODE                    --担保方式
    ,LOAN_DIR_RGN                --贷款投向地区
    ,LOAN_DIR_IDY                --贷款投向行业
    ,SYN_LOAN_FLG                --银团贷款标志
    ,PROJ_LOAN_FLG               --项目贷款标志
    ,IDY_STRU_ADJ_TYP            --产业结构调整类型
    ,IDY_TRNST_UPG_FLG           --工业转型升级标志
    ,STRTG_EMER_IDY_TYP          --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
    ,AGR_REL_LOAN_FLG            --涉农贷款标志
    ,RL_EST_LOAN_FLG             --房地产贷款标志
    ,IALL_LOAN_FLG               --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP            --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN               --贷款办理渠道
    ,NET_LOAN_FLG                --互联网贷款标志
    ,NET_LOAN_PROD_TYP           --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
    ,REPY_MODE                   --还款方式
    ,LOAN_FRM                    --贷款形式
    ,RCMM_LOAN_FLG               --重组贷款标识
    ,ADJ_BAD_FLG                 --下调为不良标志
    ,ALDY_RCMM_FLG               --曾重组标志
    ,CTON_PRD_LOAN_FLG           --缩期贷款标志
    ,CASH_TRF_FLG                --现转标志
    ,FST_LOAN_FLG                --首贷户贷款标志
    ,FIRST_LOAN_FLG              --首次贷款标志
    ,PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE          --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
    ,RATE_RE_PRC_DT              --利率重新定价日期
    ,RATE_FLT_FREQ               --利率浮动频率
    ,RATE_TYP                    --利率类型
    ,AST_SCRTZ_PROD_ID           --资产证券化产品编号
    ,EXEC_RATE                   --执行利率
    ,BASE_RATE                   --基准利率
    ,CNTR_GUA_LOAN_FLG           --反担保贷款标志
    ,RATE_FLT_VAL                --利率浮动值
    ,PRC_BASE_TYP                --定价基准类型
    ,TOT_PRD_NUM                 --总期数
    ,CURR_PRD                    --当前期数
    ,CUM_DEBT_PRD_NUM            --累计欠款期数
    ,CNU_DEBT_PRD_NUM            --连续欠款期数
    ,EXTN_CNT                    --展期次数
    ,DSBR_MODE                   --放款方式
    ,INT_CALC_MODE               --计息方式
    ,MRGN_PCT                    --保证金比例
    ,MRGN_CUR                    --保证金币种
    ,MRGN                        --保证金
    ,MRGN_ACC                    --保证金账号
    ,LOAN_OFR_NO                 --信贷员工号
    ,ACCRD_INT                   --应计利息
    ,PRO_IMPT                    --减值准备
    ,COM_PRO                     --一般准备
    ,SPCL_PRO                    --专项准备
    ,ESP_PRO                     --特别准备
    ,SPCL_LOAN_FLG               --专项贷款标志
    ,ORIG_RCPT_NO                --原借据号
    ,FND_PCT                     --出资比例
    ,ETR_ACC                     --入账账号
    ,ETR_ACC_NM                  --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
    ,REPY_ACC                    --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
    ,RCPT_STAT                   --借据状态
    ,ACC_STAT                    --账户状态
    ,REV_LOAN_FLG                --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
    ,BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                --境内外标志
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,LMT_CONT_ID                 --额度合同编号
    ,GXH_PAY_TYPE                --还款方式
    ,GXH_PAY_FREQ                --还款频度
    ,ASSET_TRAN_DT               --资产转让日期
    ,LOAN_DIR_BIO_FLG            --贷款投向境内外标识
    ,REFAC_FLG                   --支小再贷款标识
    ,BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD               --贷款形态代码
    ,OPER_ORG_ID                 --经办机构编号
    ,OPER_TELLER_ID              --经办柜员编号
    ,LOAN_ACT_FIRST_DT           --本行首贷日期
    ,RENEW_EXP_DAY               --展期到期日期
    ,FIR_LON_DT                  --征信首贷日期
    ,LOAN_MGR_ID                 --借据主办客户经理号
    ,LOAN_TELLER_ID              --借据主办柜员号
    ,LOAN_MGR_NAME               --借据主办客户经理名称
    ,LOAN_MGR_BELONG_ORG_ID      --借据主办客户经理所属机构
    ,CNCL_DT                     --核销日期
    ,FIXED_INT_MARK              --利率是否固定
    ,IN_BS_INT                   --表内利息
    ,OFF_BS_INT                  --表外利息
    ,DISTR_AMT                   --放款金额
    ,DISTR_DT                    --放款日期
    ,EAST_FLG                    --EAST口径标识
    ,CTR_NT_ID                   --成交单编号
    ,RECVBL_PNLT                 --应收罚息
    ,COLL_PNLT                   --催收罚息
    ,RECVBL_COMP_INT             --应收复息
    ,RECVBL_INT_SUB              --应收贴息
    ,RECVBL_FINE                 --应收罚息
    ,RECVBL_OVER_INT             --应收欠息
    ,COLL_OVER_INT               --催收欠息
    ,LOAN_USEAGE_SUB_CL          --贷款用途细类
    ,CUST_CHAR                   --客户性质
    ,OUT_ACCT_FLOW_NUM           --出账流水号
    ,ICMS_CUST_ID                --信贷客户编号
    ,LC_BENEFC                   --信用证受益人
    ,FIX_INT_RAT_FLG             --固定利率标志
    ,LC_ISSUER                   --信用证开证人
    ,BASE_RAT_IMAS               --基准利率IMAS    --ADD BY LIP 20230810
    ,ABS_FLG                     --资产证券化标志
    ,ASSET_TRAN_FLG              --资产转让标志
    ,REPL_OLD_BOND_FLG           --置换旧债标志    --ADD BY yjy 20240401
    ,RENEW_FLG_WDQ               --展期未到期标志  --ADD BY LWB 20240408
    ,PAYOFF_DT                   --结清日期        --ADD BY YJY 20241022
    ,SUIT_FEE_BAL                --诉讼费余额      --ADD BY YJY 20241217
    ,GREEN_CRDT_CUST_FLG         --绿色信贷客户标志  --ADD BY YJY 20250508
    ,GREEN_CRDT_CLS_CD           --绿色信贷分类_旧版代码 --ADD BY YJY 20250508
    ,GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
    ,YBT_FLG                     --一表通口径标识 --ADD BY PSF 20250916
	  ,SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
	  ,BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
	  ,SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
    )
    WITH CL_INVOICE_OD_DETAIL AS (
  SELECT ACCT_ID,CURR_PD
         ,SUM(CASE WHEN DOC_BAL > 0 AND DOC_FULL_AMT_CALLBK_FLG = '0' THEN 1 ELSE 0 END) AS SFHK
         --MOD BY 20240308 判断逾期利息、罚息、复利有没有逾期
         ,SUM(CASE WHEN ISS_AMT > 0 AND (FINAL_STL_DT > GRACE_DT OR FINAL_STL_DT = TO_DATE('00010101','YYYYMMDD'))
                   THEN 1 ELSE 0 END) AS SFYQ
    FROM RRP_MDL.O_IML_EVT_PNLT_COMP_INT_NOMAL_REPAY_DTL OV   --罚息复利正常还款明细
   WHERE OV.GRACE_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')  --没到宽限期的算正常，不算逾期
     AND OV.GRACE_DT <> TO_DATE('00010101','YYYYMMDD')
     AND OV.ISS_FLG = '1'
     AND OV.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   GROUP BY ACCT_ID,CURR_PD),
  CORP_LOAN_REPAY_PLAN AS (
  SELECT N.ACCT_ID,N.DUBIL_ID,N.TOT_PERDS,N.REPAY_PERDS,N.REPAYBL_DT,N.ETL_DT,
         MAX(N.VALUE_DT) VALUE_DT,
         --MOD BY LIP 20231107 数仓的逾期标志是指现在是否仍然逾期，EAST需要用历史是否逾期标志
         SUM(CASE WHEN N.PD_H_OVDUE_FLG = '1' THEN 1 ELSE 0 END) OVDUE_FLG, --逾期标志为是 0为否
         CASE WHEN MIN(N.REPAY_FLG) = '0' THEN 0 ELSE 1 END REPAY_FLG  --N.REPAY_FLG = '0'  --未偿还
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN N  --对公贷款还款计划
   WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY N.ACCT_ID,N.DUBIL_ID,N.TOT_PERDS,N.REPAY_PERDS,N.REPAYBL_DT,N.ETL_DT),
  CORP_LOAN_REPAY_PLAN_1 AS(
  SELECT N.DUBIL_ID,
         MAX(N.TOT_PERDS) TOT_PERDS,
         MAX(N.REPAY_PERDS) REPAY_PERDS,
         MIN(CASE WHEN N.REPAYBL_DT > TO_DATE(V_P_DATE,'YYYYMMDD') THEN N.REPAY_PERDS ELSE N.TOT_PERDS END) CURR_PERDS,
         SUM(CASE WHEN (N.OVDUE_FLG >= 1 --逾期标志为是
                        AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                        AND N.REPAY_FLG = 0) --未偿还
                       OR (CL.SFHK > 0) --欠息是否偿还
                  THEN 1 ELSE 0 END) LXQKQS, --连续欠款期数
         --MOD BY 20240308 判断逾期利息、罚息、复利有没有逾期
         SUM(CASE WHEN N.OVDUE_FLG >= 1 OR (CL.SFYQ > 0) THEN 1 ELSE 0 END) LJQKQS --累计欠款期数 --历史是否逾期标志为是
    FROM CORP_LOAN_REPAY_PLAN N --对公贷款还款计划 --MODIFY BY HULJ20221107  连续欠款期数,累计欠款期数
    LEFT JOIN CL_INVOICE_OD_DETAIL CL
      ON CL.ACCT_ID = N.ACCT_ID
     AND CL.CURR_PD = N.REPAY_PERDS
   WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY N.DUBIL_ID),
  DSBR_MODE_TMP AS ( --ADD BY LIP 20260316 根据上游口径调整：非零部分只需判断受托支付表中是否存在来判断是否受托支付
  SELECT T2.DUBIL_ID,
         MAX(T3.ENTR_PAY_AMT) AS TOT_ENTR_PAY_AMT
    FROM RRP_MDL.O_IML_AGT_ENTR_PAY_INFO_H T1 --受托支付信息历史 --ICMS_PAYMENT_INFO
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T2 --对公贷款借据信息
      ON T2.OUT_ACCT_FLOW_NUM = T1.OUT_ACCT_FLOW_NUM
     AND T2.STD_PROD_ID NOT LIKE '20304%' --剔除垫款
     AND T2.STD_PROD_ID NOT LIKE '2030306%' --剔除国内福费廷
     AND T2.STD_PROD_ID NOT LIKE '2030203%' --剔除国际福费廷
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H T3 --贷款出账申请历史 --ADD BY LIP 20230829
      ON T3.OUT_ACCT_FLOW_NUM = T1.OUT_ACCT_FLOW_NUM
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T2.DUBIL_ID)
  SELECT /*+PRALLEL(4)*/ V_P_DATE                                        AS DATA_DT                     --数据日期
        ,A.LP_ID                                                         AS LGL_REP_ID                  --法人编号
        ,B.ACCT_ID                                                       AS ACC_ID                      --账户编号
        ,A.DUBIL_ID                                                      AS RCPT_ID                     --借据编号
        ,NVL(E.CONT_ID,B.CONT_ID)                                        AS CONT_ID                     --合同编号
        ,NVL(TRIM(A.BILL_NUM),TRIM(L1.BILL_NUM))                         AS BILL_NO                     --票据号码
        ,NULL                                                            AS COOP_AGRT_ID                --合作协议编号
        ,B.CUST_ID                                                       AS CUST_ID                     --客户编号
        ,B.ACCT_INSTIT_ID                                                AS ORG_ID                      --机构编号
        ,B.SUBJ_ID                                                       AS SUBJ_ID                     --科目编号
        ,A.STD_PROD_ID                                                   AS LOAN_STD_PROD_ID            --贷款标准产品编号
        ,C.PROD_NAME                                                     AS LOAN_STD_PROD_NM            --贷款标准产品名称
        ,C.PROD_ID                                                       AS LOAN_PROD_ID                --贷款产品编号
        ,C.PROD_NAME                                                     AS LOAN_PROD_NM                --贷款产品名称
        ,NVL(TA.TAR_VALUE_CODE,A.STD_PROD_ID)                            AS LOAN_BIZ_TYP                --贷款业务类型
        ,A.CURR_CD                                                       AS CUR                         --币种
        ,B.DUBIL_AMT                                                     AS LOAN_AMT                    --借款金额
        ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 0
              WHEN B.WRT_OFF_FLG <> '1'
              THEN CASE WHEN B.SUBJ_ID LIKE '1313%'
                        THEN NVL(B.OVDUE_PRIC_BAL,0) + NVL(B.IDLE_PRIC,0) + NVL(B.BAD_DEBT_PRIC,0)
                        ELSE NVL(B.PRIC_BAL,0) - NVL(B.WRT_OFF_PRIC,0)
                    END
          END                                                             AS LOAN_BAL                    --贷款余额
        ,B.TRADE_FIN_INT_ADJ                                              AS INT_ADJ                     --利息调整
        ,NVL(AA.N_PV_VARIATION,0)                                         AS FAIR_VAL_CHG                --公允价值变动
        ,CASE WHEN B.WRT_OFF_FLG = '1'
              THEN 0
              ELSE B.OVDUE_PRIC + B.IDLE_PRIC + B.BAD_DEBT_PRIC
          END                                                             AS OVD_PRIN_BAL                --逾期本金余额
        ,B.IN_BS_OVER_INT_BAL                                             AS IN_INT_OVD_BAL              --表内欠息余额
        ,B.OFF_BS_OVER_INT_BAL                                            AS OUT_INT_OVD_BAL             --表外欠息余额
        ,CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') IN ('00010101','29991231')
              THEN NULL
              ELSE TO_CHAR(B.DISTR_DT,'YYYYMMDD')
          END                                                             AS LOAN_ACT_DSTR_DT            --贷款实际发放日期
        ,CASE WHEN B.RENEW_FLG = '1'
              THEN TO_CHAR(A.EXEC_EXP_DT,'YYYYMMDD')
              ELSE TO_CHAR(A.APOT_EXP_DT,'YYYYMMDD')
          END                                                             AS LOAN_ORIG_EXP_DT            --贷款原始到期日期
        ,TO_CHAR(B.EXP_DT,'YYYYMMDD')                                     AS LOAN_ACT_EXP_DT             --贷款实际到期日期
        ,CASE WHEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101')
               AND D.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')
              WHEN TO_CHAR(B.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101')
               AND B.ASSET_TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TO_CHAR(B.ASSET_TRAN_DT,'YYYYMMDD')
              WHEN TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD')
              ELSE '29991231'
          END                                                              AS ACT_END_DT                  --实际终止日期
        ,TO_CHAR(B.LAST_REPAY_DT,'YYYYMMDD')                               AS LAST_REPY_DT                --上次还款日期
        ,M1.LAST_REPY_AMT                                                  AS LAST_REPY_AMT               --上次还款金额
        ,CASE WHEN TO_CHAR(B.VALUE_DT,'YYYYMMDD') IN ('00010101','29991231')
              THEN NULL
              ELSE TO_CHAR(B.VALUE_DT,'YYYYMMDD')
          END                                                              AS VAL_DT                      --起息日期
        ,CASE WHEN TO_CHAR(B.OPEN_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231')
              THEN NULL
              ELSE TO_CHAR(B.OPEN_ACCT_DT,'YYYYMMDD')
          END                                                              AS OPEN_ACC_DT                 --开户日期
        ,CASE WHEN TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231')
              THEN NULL
              ELSE TO_CHAR(B.CLOS_ACCT_DT,'YYYYMMDD')
          END                                                              AS CNL_ACC_DT                  --销户日期
        ,CASE WHEN B.PRIC_OVDUE_DAYS > 0
              THEN TO_CHAR(B.ETL_DT - B.PRIC_OVDUE_DAYS,'YYYYMMDD')
          END                                                              AS PRIN_OVD_DT                 --本金逾期日期
        ,CASE WHEN B.INT_OVDUE_DAYS > 0
              THEN TO_CHAR(B.ETL_DT - B.INT_OVDUE_DAYS,'YYYYMMDD')
          END                                                              AS INT_OVD_DT                  --利息逾期日期
        ,GREATEST(B.PRIC_OVDUE_DAYS,B.INT_OVDUE_DAYS)                      AS OVD_DAYS                    --逾期天数
        ,CASE WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS > 0
              THEN '03'  --03：本金利息逾期
              WHEN B.PRIC_OVDUE_DAYS > 0 AND B.INT_OVDUE_DAYS = 0
              THEN '01'  --01：本金逾期
              WHEN B.PRIC_OVDUE_DAYS = 0 AND B.INT_OVDUE_DAYS > 0
              THEN '02'  --02：利息逾期
              ELSE NULL
         END                                                               AS OVD_TYP                     --逾期类型
        ,CASE WHEN TRIM(E.LOAN_USAGE_DESCB) IS NOT NULL
              THEN E.LOAN_USAGE_DESCB
              WHEN A.STD_PROD_ID IN ('203010500001','402020100003')
              THEN '企业日常经营周转' --法透、同业法透
              WHEN A.STD_PROD_ID LIKE ('203040%')
              THEN '其他-垫款'
          END                                                              AS LOAN_USEAGE                 --贷款用途
        ,TB.TAR_VALUE_CODE                                                 AS LVL5_CL                     --五级分类
        ,TTM.TAR_VALUE_CODE                                                AS GUA_MODE                    --担保方式
        ,CASE WHEN G.RG_CD = '810000' THEN 'HKG'
              WHEN G.RG_CD = '820000' THEN 'MAC'
              WHEN G.RG_CD = '710000' THEN 'TWN'
              WHEN NVL(TRIM(G.INVTOR_CTY_CD),'1111') NOT IN ('CHN','XXX','1111')
              THEN TRIM(G.INVTOR_CTY_CD)
              WHEN TRIM(G.RG_CD) NOT IN ('1000','999999','000000')
              THEN TRIM(G.RG_CD)
              WHEN TRIM(F.DIST_CD) NOT IN ('1000','999999','000000')
              THEN TRIM(F.DIST_CD)
          END                                                              AS LOAN_DIR_RGN               --贷款投向地区 modify by hulj 20221108补充客户的地区代码，身份证类型判断时加上临时身份证
        ,A.DIR_INDUS_CD                                                    AS LOAN_DIR_IDY               --贷款投向行业
        ,CASE WHEN B.SUBJ_ID = '13030104'
              THEN 'Y'
              ELSE 'N'
         END                                                               AS SYN_LOAN_FLG               --银团贷款标志
        ,NVL(CONFIG1.PROJ_LOAN_FLG,'N')                                    AS PROJ_LOAN_FLG              --项目贷款标志--modify by hulj 剔除经营性物业贷款,并购贷款
        ,NULL                                                              AS IDY_STRU_ADJ_TYP           --产业结构调整类型
        ,NULL                                                              AS IDY_TRNST_UPG_FLG          --工业转型升级标志
        ,NULL                                                              AS STRTG_EMER_IDY_TYP         --战略新兴产业类型
        ,'N'                                                               AS BANK_TAX_COOP_LOAN_FLG     --银税合作贷款标志
        ,CASE WHEN E.AGCLT_FLG = '1' THEN 'Y' ELSE 'N' END                 AS AGR_REL_LOAN_FLG           --涉农贷款标志
        ,CASE WHEN E.ESTATE_LOAN_TYPE_CD IS NULL THEN 'N' ELSE 'Y' END     AS RL_EST_LOAN_FLG            --房地产贷款标志
        ,NULL                                                              AS IALL_LOAN_FLG              --投贷联动贷款标志
        ,NULL                                                              AS OV_SEA_MRG_LOAN_FLG        --境外并购贷款标志
        ,NULL                                                              AS GRN_LOAN_USEAGE_CL         --绿色贷款用途分类
        ,NULL                                                              AS ENT_GUA_LOAN_TYP           --创业担保贷款类型
        ,NULL                                                              AS CAMPUS_CNSMP_LOAN_FLG      --校园消费贷款标志
        ,CASE WHEN B.GOVER_FIN_PLAT_LOAN_FLG = '1' THEN 'Y' ELSE 'N' END   AS LCL_GOVFINPLTF_LOAN_FLG    --地方政府融资平台贷款标志
        ,NULL                                                              AS LAND_THIRDPARTY_LOAN_TYP   --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                                              AS FARMER_THIRDPARTY_LOAN_TYP --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                                              AS POV_ALLE_REC_FLG           --未脱贫建档立卡户贷款标志
        ,TJ.TAR_VALUE_CODE                                                 AS LOAN_HDL_CHAN              --贷款办理渠道
        ,'N'                                                               AS NET_LOAN_FLG               --互联网贷款标志
        ,'0'                                                               AS NET_LOAN_PROD_TYP          --网贷产品类别
        ,NULL                                                              AS CR_CRD_BIZ_OD_TYP          --类信用卡业务透支类型
        ,CASE WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '1M' THEN '01' --按月
              WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '3M' THEN '02' --按季
              WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '6M' THEN '03' --按半年
              WHEN B.REPAY_PED||B.REPAY_PED_CORP_CD = '12M' THEN '04' --按年
              ELSE TC.TAR_VALUE_CODE
          END                                                              AS REPY_MODE                  --还款方式
        ,CASE WHEN A.DUBIL_ID IN ('2019102813808005','2019102813808006','2019102813808007','20230728000167001','20221215023001', '20221216122340001', '20221208122325001', '20221211001001', '20221216122341001') 
              THEN '04'  -- 重组
              WHEN CZ1.DUEBILLSERIALNO IS NOT NULL THEN '9906' -- 9906-其他-调整还款计划  --ADD BY YJY 20260319增加判断对公信贷重组贷款的逻辑，信贷系统未对重组类型-调整还款计划的合同进行改造
              WHEN /*E.REGROUP_TYPE_CD*/ CZ.RENEWALTYPE IN ('VAL') --续期 --UPDATE BY YJY 20260311 
              THEN '05' --05-无还本续贷  
              WHEN /*E.REGROUP_TYPE_CD*/ CZ.RENEWALTYPE IN ('REP') --调整还款计划 --UPDATE BY YJY 20260311 
              THEN '9906' --9906-其他-调整还款计划  --MOD BY YJY 20251226 按照业务王玲的要求，在业务合同层里发生类型是“重组”的才抽取出来。重组方式“续期”金数归“01”续贷，“调整还款计划”归”03“其他
              WHEN WHBXD.DUBIL_ID IS NOT NULL
              THEN '05'  --05-无还本续贷         --MOD BY YJY 20250103 无还本续贷通过借据取信贷系统打的标签，其他仍通过合同的贷款形式映射码值             
              ELSE TD.TAR_VALUE_CODE
          END                                                               AS LOAN_FRM                   --贷款形式
        /*,CASE WHEN E.LOAN_HAPP_TYPE_CD IN ('0201','0204','0202') THEN 'Y' --0201展期 0204债务重组 0202借新还旧
              ELSE 'N'
          END*/
        ,CASE WHEN /*E.REGROUP_TYPE_CD*/ CZ.RENEWALTYPE IN ('VAL','REP') --VAL续期、REP调整还款计划 --UPDATE BY YJY 20260311 
              THEN 'Y' ----MOD BY YJY 20251226 按照业务王玲的要求，在业务合同层里发生类型是“重组”的才抽取出来。重组方式“续期”金数归“01”续贷，“调整还款计划”归”03“其他
              WHEN CZ1.DUEBILLSERIALNO IS NOT NULL THEN 'Y'
              /*WHEN CZ.OBJECTNO  IS NOT NULL
              THEN 'Y' --MOD BY YJY 20250303 优先关联信贷系统贷款重组关联表的借据
              WHEN E.LOAN_HAPP_TYPE_CD IN ('0201','0204','0202')
              THEN 'Y' --0201展期 0204债务重组 0202借新还旧 */ --MOD BY YJY 20251226 王玲确认因信贷系统优化了发生额类型，这部分取数逻辑不准确
              ELSE 'N'
         END                                                               AS RCMM_LOAN_FLG              --重组贷款标识
        ,NULL                                                              AS ADJ_BAD_FLG                --下调为不良标志
        ,NULL                                                              AS ALDY_RCMM_FLG              --曾重组标志
        ,NULL                                                              AS CTON_PRD_LOAN_FLG          --缩期贷款标志
        ,NULL                                                              AS CASH_TRF_FLG               --现转标志
        ,DECODE(H1.DUBIL_ID,NULL,'N','Y')                                  AS FST_LOAN_FLG               --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H1.DUBIL_ID,NULL,'N','Y')                                  AS FIRST_LOAN_FLG             --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,CASE --WHEN NVL(/*G.GREEN_CRDT_CLS_NEW*/ A.GREEN_CRDT_CLS_NEW,'-') <> '-'
              WHEN NVL(TRIM(A.GREEN_CRDT_CLS_NEW),'-') NOT IN ('-','999')  --MOD BY YJY 20250819 从借据表取绿色信贷分类_新版代码
              THEN 'Y'
              ELSE 'N'
          END                                                              AS PBOC_GRN_LOAN_FLG          --PBOC绿色贷款标志  MOD BY YJY 20250604
        ,CASE --WHEN SUBSTR(/*G.GREEN_CRDT_CLS_CD*/ A.GREEN_CRDT_CLS_NEW,1,1) IN ('A','B','C','D','E','F')
              WHEN NVL(TRIM(A.GREEN_CRDT_CLS_NEW),'-') NOT IN ('-','999')  --MOD BY YJY 20250604  --MOD BY YJY 20250819 从借据表取绿色信贷分类_新版代码
              THEN 'Y' --排除委托贷款 --modify by hulj排除203020700002  出口代付  203020700001  进口代付
              ELSE 'N'
          END                                                              AS CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
        ,NULL                                                              AS CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
        ,TXLX.TAR_VALUE_CODE                                               AS LOAN_FINC_SPT_MODE          --贷款财政扶持方式20220921 XUXIAOBIN MODIFY
        ,NULL                                                              AS ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志 MODIFY BY MW 20221229 对公无精准扶贫
        ,CASE WHEN B.NEXT_INT_RAT_ADJ_DT IN (DATE'2999-12-31',DATE'2099-12-31',DATE'0001-01-01')--20230509 XUXIAOBIN MODIFY
              THEN NULL
              ELSE TO_CHAR(B.NEXT_INT_RAT_ADJ_DT,'YYYYMMDD')
          END                                                              AS RATE_RE_PRC_DT              --利率重新定价日期
        ,CASE WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '1D' THEN '01'---按日
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD IN ('7D','1W') THEN '02'--按周
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '1M' THEN '03'---按月
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '3M' THEN '04'--按季
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '6M' THEN '05'--按半年
              WHEN B.INT_RAT_ADJ_PED_FREQ||B.INT_RAT_ADJ_PED_CORP_CD = '12M' THEN '06'--按年
              ELSE '99'
          END                                                              AS RATE_FLT_FREQ               --利率浮动频率
        ,TTK.TAR_VALUE_CODE                                                AS RATE_TYP                    --利率类型
        ,NULL                                                              AS AST_SCRTZ_PROD_ID           --资产证券化产品编号
        ,B.EXEC_INT_RAT                                                    AS EXEC_RATE                   --执行利率
        ,B.BASE_RAT                                                        AS BASE_RATE                   --基准利率
        ,NULL                                                              AS CNTR_GUA_LOAN_FLG           --反担保贷款标志
        ,E.INT_RAT_FLO_VAL                                                 AS RATE_FLT_VAL                --利率浮动值
        ,CASE WHEN B.INT_RAT_CURVE_TYPE_CD IN ('241','242') THEN 'TR07'
              ELSE TI.TAR_VALUE_CODE
          END                                                              AS PRC_BASE_TYP                --定价基准类型
        ,CASE WHEN (A.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') OR B.TOT_PERDS = 0)
              THEN B.CURR_ISSUE_PERDS --因还款计划会删除，所以如果总期数为0，则取当前期数
              WHEN NVL(B.TOT_PERDS,0) > 0 THEN NVL(B.TOT_PERDS,0)
              ELSE B.TOT_PERDS
          END                                                              AS TOT_PRD_NUM                 --总期数
        --MOD BY LIP 20231013 取处于还款计划的哪一期
        --,NVL(I.CURR_PERDS,NVL(B.CURR_ISSUE_PERDS,0))                       AS CURR_PRD                   --当前期数
        --MOD BY LIP 20251107 一表通沟通后调整当前期数的取数口径
        ,CASE WHEN B.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD') + 1 AND B.LOAN_ACCT_STATUS_CD = 'A'
              THEN NVL(B.CURR_ISSUE_PERDS,0) --借据到期日大于当前日期的时候，且状态为正常的，就取借据表的当前期次吗
              ELSE NVL(B.TOT_PERDS,0)
          END                                                              AS CURR_PRD                   --当前期数
        ,NVL(I.LJQKQS,0)                                                   AS CUM_DEBT_PRD_NUM           --累计欠款期数
        ,NVL(I.LXQKQS,0)                                                   AS CNU_DEBT_PRD_NUM           --连续欠款期数
        ,NVL(B.RENEW_CNT,0)                                                AS EXTN_CNT                   --展期次数
        /*,CASE WHEN A.MONEY_USE_TYPE_CD = '2' THEN '01'
              ELSE NVL(TE.TAR_VALUE_CODE,'01')
          END                                                              AS DSBR_MODE                  --放款方式*/
        --MOD BY LIP 20260316 受托支付表中有数（剔除垫款、福费廷成本）的就是受托支付
        ,CASE WHEN TE.DUBIL_ID IS NOT NULL THEN '02' --根据信贷反馈，支付信息表中存在时就是受托支付
              ELSE '01'
          END                                                              AS DSBR_MODE                  --放款方式 D0104
        ,NVL(TF.TAR_VALUE_CODE,'9901')                                     AS INT_CALC_MODE              --计息方式
        ,A.MARGIN_RATIO                                                    AS MRGN_PCT                   --保证金比例
        ,A.MARGIN_CURR_CD                                                  AS MRGN_CUR                   --保证金币种
        ,A.MARGIN_AMT                                                      AS MRGN                       --保证金
        ,A.MARGIN_ACCT_NUM                                                 AS MRGN_ACC                   --保证金账号
        ,CASE WHEN TRIM(B.CUST_MGR_ID) IS NOT NULL AND TRIM(B.CUST_MGR_ID) <> 'M0001'
              THEN TRIM(B.CUST_MGR_ID)
              WHEN TRIM(A.OPER_TELLER_ID) IS NOT NULL
              THEN TRIM(A.OPER_TELLER_ID)
              WHEN TRIM(E.MGMT_TELLER_ID) IS NOT NULL
              THEN TRIM(E.MGMT_TELLER_ID)
              WHEN TRIM(E.RGST_TELLER_ID) IS NOT NULL
              THEN TRIM(E.RGST_TELLER_ID)
          END                                                              AS LOAN_OFR_NO                --信贷员工号 --modify by hulj 20221107
        ,A.NEXT_TERM_REPAY_INT_AMT                                         AS ACCRD_INT                  --应计利息
        ,NULL                                                              AS PRO_IMPT                   --减值准备   --modify by mw 减值准备从减值结果表取
        ,NULL                                                              AS COM_PRO                    --一般准备
        ,NULL                                                              AS SPCL_PRO                   --专项准备
        ,NULL                                                              AS ESP_PRO                    --特别准备
        ,NULL                                                              AS SPCL_LOAN_FLG              --专项贷款标志
        ,A.RELA_DUBIL_ID                                                   AS ORIG_RCPT_NO               --原借据号
        ,CASE WHEN A.STD_PROD_ID IN ( '203010400001','203010400002')
               AND NVL(E1.SYN_LOAN_TOT_AMT,0) <> 0
              THEN (A.DUBIL_AMT / E1.SYN_LOAN_TOT_AMT) * 100
          END                                                              AS FND_PCT                    --出资比例
        ,CASE WHEN B.SUBJ_ID LIKE '131301%' THEN TZ.ETR_ACC --MOD BY LIP 20230828 --承兑垫款
              WHEN B.STD_PROD_ID IN ('203020300002','203030600002') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC --MOD BY 20240204 --二级福费廷
              WHEN B.STD_PROD_ID IN ('203030200001','203030600001') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC --MOD BY LIP 20241021 信用证下代理交单福费廷、结售汇
              WHEN B.STD_PROD_ID IN ('203020300001','203030600001') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC --MOD BY 20240204 --一级福费廷
              WHEN B.STD_PROD_ID IN ('203020700002') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC --MOD BY LIP 20251209 --出口代付
              WHEN B.STD_PROD_ID IN ('203020700002') THEN B.LOAN_REPAY_NUM --同业代付 取还款账号 MOD BY LIP 20230531 按严希婧口径更新
              WHEN B.STD_PROD_ID LIKE '2030305%' AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC --MOD BY LIP 20250613 保理
              WHEN TRIM(B.LOAN_DISTR_ACCT_NUM) IS NOT NULL THEN TRIM(B.LOAN_DISTR_ACCT_NUM)
          END                                                              AS ETR_ACC                    --入账账号 --modify by hulj
        ,CASE WHEN B.SUBJ_ID LIKE '131301%' THEN TZ.ETR_ACC_NM --MOD BY LIP 20230828 --承兑垫款
              WHEN B.STD_PROD_ID IN ('203020300002','203030600002') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC_NM --MOD BY 20240204 --二级福费廷
              WHEN B.STD_PROD_ID IN ('203030200001','203030600001') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC_NM --MOD BY LIP 20241021 信用证下代理交单福费廷、结售汇
              WHEN B.STD_PROD_ID IN ('203020300001','203030600001') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC_NM --MOD BY 20240204 --一级福费廷
              WHEN B.STD_PROD_ID IN ('203020700002') AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC_NM --MOD BY LIP 20251209 --出口代付
              WHEN B.STD_PROD_ID IN ('203020700002') THEN J.CUST_ACCT_NAME --同业代付 取还款账号 MOD BY LIP 20230531 按严希婧口径更新
              WHEN B.STD_PROD_ID LIKE '2030305%' AND TZ.ETR_ACC IS NOT NULL THEN TZ.ETR_ACC_NM --MOD BY LIP 20250613 保理
              WHEN TRIM(JJ.CUST_ACCT_NAME) IS NOT NULL THEN TRIM(JJ.CUST_ACCT_NAME)
              WHEN TRIM(A.RECVBL_ACCT_NAME) IS NOT NULL THEN TRIM(A.RECVBL_ACCT_NAME)
          END                                                              AS ETR_ACC_NM                 --入账账号户名
        ,CASE WHEN B.SUBJ_ID LIKE '131301%' THEN TZ.LOAN_ETR_ACC_OPEN_BANK_NM --MOD BY LIP 20230828 --承兑垫款
              WHEN B.STD_PROD_ID IN ('203020300002','203030600002') AND TZ.ETR_ACC IS NOT NULL THEN TZ.LOAN_ETR_ACC_OPEN_BANK_NM --MOD BY 20240204 --二级福费廷
              WHEN B.STD_PROD_ID IN ('203030200001','203030600001') AND TZ.ETR_ACC IS NOT NULL THEN TZ.LOAN_ETR_ACC_OPEN_BANK_NM --MOD BY LIP 20241021 信用证下代理交单福费廷、结售汇
              WHEN B.STD_PROD_ID IN ('203020300001','203030600001') AND TZ.ETR_ACC IS NOT NULL THEN TZ.LOAN_ETR_ACC_OPEN_BANK_NM --MOD BY 20240204 --一级福费廷
              WHEN B.STD_PROD_ID IN ('203020700002') AND TZ.ETR_ACC IS NOT NULL THEN TZ.LOAN_ETR_ACC_OPEN_BANK_NM --MOD BY LIP 20251209 --出口代付
              WHEN B.STD_PROD_ID IN ('203020700002') THEN J.ORG_NAME --同业代付 取还款账号 MOD BY LIP 20230531 按严希婧口径更新
              WHEN B.STD_PROD_ID LIKE '2030305%' AND TZ.ETR_ACC IS NOT NULL THEN TZ.LOAN_ETR_ACC_OPEN_BANK_NM --MOD BY LIP 20250613 保理
              WHEN TRIM(JJ.ORG_NAME) IS NOT NULL THEN TRIM(JJ.ORG_NAME)
              WHEN TRIM(A.RECVBL_BANK_NAME) IS NOT NULL THEN TRIM(A.RECVBL_BANK_NAME)
          END                                                              AS LOAN_ETR_ACC_OPEN_BANK_NM  --贷款入账账号开户行名称/*HULJ20221008*/
        /*,B.LOAN_REPAY_NUM                                                  AS REPY_ACC                   --还款账号
        ,J.ORG_NAME                                                        AS LOAN_REPY_ACC_OPEN_BANK_NM --贷款还款账号开户行名称*/
        ,CASE WHEN T1.DUBIL_NUM IS NOT NULL THEN T1.OTH_REAL_BASE_ACCT_NO
              ELSE B.LOAN_REPAY_NUM
          END                                                              AS REPY_ACC                   --还款账号 --MOD BY LIP 20251222
        ,CASE WHEN T1.DUBIL_NUM IS NOT NULL THEN T1.CONTRA_BANK_NAME
              ELSE J.ORG_NAME
          END                                                              AS LOAN_REPY_ACC_OPEN_BANK_NM --贷款还款账号开户行名称 --MOD BY LIP 20251222
        ,CASE WHEN B.WRT_OFF_FLG = '1' THEN 'C0201' --核销
              WHEN B.ASSET_TRAN_STATUS_CD = '121' THEN 'C0202' --转让
              --MOD BY LIP 20251021 因抽数时点问题，会导致信贷提前判断为结清，这种情况改成通过核心的状态判断
              WHEN A.DUBIL_STATUS_CD = 'C' AND B.CLOS_ACCT_DT >= TO_DATE(V_P_DATE,'YYYYMMDD') AND B.LOAN_ACCT_STATUS_CD = 'A'
              THEN 'A' --信贷的状态是关闭，核心的是正常
              WHEN A.DUBIL_STATUS_CD = 'C' AND B.CLOS_ACCT_DT >= TO_DATE(V_P_DATE,'YYYYMMDD') AND B.LOAN_ACCT_STATUS_CD = 'P'
              THEN 'B' --信贷的状态是关闭，核心的是逾期
              ELSE TG.TAR_VALUE_CODE
          END                                                              AS RCPT_STAT                  --借据状态
        ,CASE WHEN TH.TAR_VALUE_CODE IS NOT NULL THEN TH.TAR_VALUE_CODE
              WHEN B.LOAN_ACCT_STATUS_CD = '0' THEN '02'
              WHEN B.LOAN_ACCT_STATUS_CD = '1' THEN '01'
              WHEN B.LOAN_ACCT_STATUS_CD = '2' THEN '02'
              WHEN B.LOAN_ACCT_STATUS_CD = '3' THEN '01'
              WHEN B.LOAN_ACCT_STATUS_CD = '4' THEN '01'
              WHEN B.LOAN_ACCT_STATUS_CD = '5' THEN '02'
          END                                                              AS ACC_STAT                    --账户状态
        ,CASE WHEN A.STD_PROD_ID IN ('203010100002','203010500001') THEN 'Y'
              WHEN T20.CHANNEL IN ('XB','KSW') THEN 'Y'
              ELSE 'N'
          END                                                              AS REV_LOAN_FLG                --循环贷贷款标志
        ,NULL                                                              AS REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
        ,B.NEXT_REPAY_INT_AMT                                              AS BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
        ,CASE WHEN G.DOM_OVERS_FLG IN ('1','@1') THEN 'Y'
              WHEN G.DOM_OVERS_FLG = '0' THEN 'N'
              ELSE 'Y'
          END                                                              AS BIO_LOAN_FLG                --境内外标志--MODIFY BY MW 20221103 ,1-境内，0境外
        ,NULL                                                              AS DEPT_LINE                   --部门条线
        ,'对公信贷'                                                        AS DATA_SRC                    --数据来源
        ,E.LMT_CONT_ID                                                     AS LMT_CONT_ID                 --额度合同编号
        ,B.REPAY_WAY_CD                                                    AS GXH_PAY_TYPE                --还款方式
        ,B.REPAY_PED_CORP_CD                                               AS GXH_PAY_FREQ                --还款频率
        ,TO_CHAR(B.ASSET_TRAN_DT,'YYYYMMDD')                               AS ASSET_TRAN_DT               --资产转让日期
        ,CASE WHEN A.OVERS_LOAN_FLG = '1' THEN 'N'--境外
              WHEN A.OVERS_LOAN_FLG = '0' THEN 'Y'--境内
              ELSE 'Y' --未知
          END                                                              AS LOAN_DIR_BIO_FLG            --贷款投向境内外标识
        ,CASE WHEN A.REFAC_LOAN_STATUS_CD = '1' THEN 'Y'
              ELSE 'N'
          END                                                              AS REFAC_FLG                   --支小再贷款标识
        ,CASE WHEN A.STD_PROD_ID IN ('203020300002','203030600002','203020300001','203030600001') --福费廷
              THEN B.DUBIL_AMT * (1 - NVL(INT_SUB_RATIO,0))  --贴息后的金额
          END                                                               AS BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
        ,B.LOAN_MODAL_CD                                                    AS LOAN_MODAL_CD               --贷款形态代码
        ,A.OPER_ORG_ID                                                      AS OPER_ORG_ID                 --经办机构编号 ADD BY HULJ 20221122
        ,A.OPER_TELLER_ID                                                   AS OPER_TELLER_ID              --经办柜员编号 ADD BY HULJ 20221122
        ,H2.LOAN_ACT_DSTR_DT                                                AS LOAN_ACT_FIRST_DT           --本行首贷日期 ADD BY HULJ 20221122
        ,TO_CHAR(B.RENEW_EXP_DAY,'YYYYMMDD')                                AS RENEW_EXP_DAY               --展期到期日期 ADD BY HULJ 20221122
        ,TO_CHAR(G.FIR_LON_DT,'YYYYMMDD')                                   AS FIR_LON_DT                  --征信首贷日期 ADD BY HULJ 20221123
        ,A.RGST_TELLER_ID                                                   AS LOAN_MGR_ID                 --借据主办客户经理号 ADD BY HULJ 20221123
        ,A.RGST_TELLER_ID                                                   AS LOAN_TELLER_ID              --借据主办柜员号 ADD BY HULJ 20221123
        ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)                               AS LOAN_MGR_NAME               --借据主办客户经理名称 ADD BY HULJ 20221123
        ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID)                           AS LOAN_MGR_BELONG_ORG_ID      --借据主办客户经理所属机构 ADD BY HULJ 20221123
        ,TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')                               AS CNCL_DT                     --核销日期
        ,B.INT_RAT_ADJ_WAY_CD                                               AS FIXED_INT_MARK              --利率是否固定
        ,B.IN_BS_INT                                                        AS IN_BS_INT                   --表内利息
        ,B.OFF_BS_INT                                                       AS OFF_BS_INT                  --表外利息
        ,B.DISTR_AMT                                                        AS DISTR_AMT                   --放款金额
        ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')                                     AS DISTR_DT                    --放款日期
        ,CASE WHEN (B.CLOS_ACCT_DT >= V_MONTH_START_DATE OR B.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(B.CURRT_BAL,0) >0)
              AND (NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE OR D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD'))
              AND (NVL(B.ASSET_TRAN_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE OR B.ASSET_TRAN_DT = TO_DATE('00010101','YYYYMMDD'))
              THEN 'Y'
              ELSE 'N'
          END                                                               AS EAST_FLG                    --EAST口径标识
        ,NULL                                                               AS CTR_NT_ID                   --成交单编号
        ,B.RECVBL_PNLT                                                      AS RECVBL_PNLT                 --应收罚息
        ,NULL                                                               AS COLL_PNLT                   --催收罚息
        ,B.RECVBL_COMP_INT                                                  AS RECVBL_COMP_INT             --应收复息
        ,NULL                                                               AS RECVBL_INT_SUB              --应收贴息
        ,NULL                                                               AS RECVBL_FINE                 --应收罚金
        ,B.RECVBL_OVER_INT                                                  AS RECVBL_OVER_INT             --应收欠息
        ,NULL                                                               AS COLL_OVER_INT               --催收欠息
        ,NULL                                                               AS LOAN_USEAGE_SUB_CL          --贷款用途细类
        ,NULL                                                               AS CUST_CHAR                   --客户性质
        ,A.OUT_ACCT_FLOW_NUM                                                AS OUT_ACCT_FLOW_NUM           --出账流水号
        ,A.CUST_ID                                                          AS ICMS_CUST_ID                --信贷客户编号
        ,A8.LC_BENEFC                                                       AS LC_BENEFC                   --信用证受益人
        ,A8.FIX_INT_RAT_FLG                                                 AS FIX_INT_RAT_FLG             --固定利率标志
        ,A8.LC_ISSUER                                                       AS LC_ISSUER                   --信用证开证人
        ,CASE WHEN NVL(A.BASE_RAT,0) <> 0 THEN A.BASE_RAT
              WHEN NVL(TBA.BASE_RAT,0) <> 0 THEN TBA.BASE_RAT
              ELSE NVL(TBAB.BASE_RAT,0)
          END                                                               AS BASE_RAT_IMAS               --基准利率IMAS --ADD BY LIP 20230810
        ,B.ABS_FLG                                                          AS ABS_FLG                     --资产证券化标志
        ,B.ASSET_TRAN_FLG                                                   AS ASSET_TRAN_FLG              --资产转让标志
        ,A.REPL_OLD_BOND_FLG                                                AS REPL_OLD_BOND_FLG           --置换旧债标志  --ADD BY yjy 20240401
        ,CASE WHEN B.RENEW_FLG = '1'
               AND A.APOT_EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN 'Y'--展期未到期贷款 ADD BY LWB
              ELSE 'N'
          END                                                               AS RENEW_FLG_WDQ
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')                                    AS PAYOFF_DT                   --结清日期       --ADD BY YJY 20241022
        ,NVL(A.SUIT_FEE_BAL,0)                                              AS SUIT_FEE_BAL                --诉讼费余额     --ADD BY YJY 20241217
        ,A.GREEN_CRDT_CUST_FLG                                              AS GREEN_CRDT_CUST_FLG         --绿色信贷客户标志  --ADD BY YJY 20250508
        ,A.GREEN_CRDT_CLS_CD                                                AS GREEN_CRDT_CLS_CD           --绿色信贷分类_旧版代码 --ADD BY YJY 20250508
        ,A.GREEN_CRDT_CLS_NEW                                               AS GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
        ,CASE WHEN (B.CLOS_ACCT_DT >= V_YEAR_START_DATE OR B.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(B.CURRT_BAL,0) >0)
              AND (NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE OR D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD'))
              AND (NVL(B.ASSET_TRAN_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE OR B.ASSET_TRAN_DT = TO_DATE('00010101','YYYYMMDD'))
              THEN 'Y'
              ELSE 'N'
          END                                                               AS YBT_FLG                    --一表通口径标识
	      ,CASE WHEN BG.CONT_ID IS NOT NULL 
               AND BG.TAGID = '2026031090000004' 
			         AND BG.TAGVALUE = '1' 
		          THEN 'Y'
			        ELSE 'N'
		      END                                                               AS SFJWBGDK                   --是否境外并购贷款  ADD BY YJY 20260312
	      ,CASE WHEN BG.CONT_ID IS NOT NULL 
               AND BG.TAGID = '2026031090000005' 
			        THEN BG.TAGVALUE  --10-控制型并购贷款 20-参股型并购贷款
		      END                                                               AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
	      ,CASE WHEN JR.CUST_ID IS NOT NULL 
               AND JR.TAGVALUE = '1'  
		          THEN 'Y'
			        ELSE 'N'
		      END                                                               AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
   FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
  INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息表
     ON B.DUBIL_NUM = A.DUBIL_ID
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C --标准产品信息表
     ON C.PROD_ID = A.STD_PROD_ID
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO D --贷款核销信息
     ON D.DUBIL_ID = A.DUBIL_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E --对公贷款合同信息
     ON E.CONT_ID = A.CONT_ID
    AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO E1 --对公贷款合同信息
     ON E1.CONT_ID = E.LMT_CONT_ID
    AND E1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H T3 --贷款出账申请历史
     ON T3.DUBIL_ID = A.DUBIL_ID
    AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H A8 --贷款出账对公贷款附属信息历史add by hulj20230728
     ON A8.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
    AND A8.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A8.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN (SELECT DUBIL_ID
                     ,REPAY_DT
                     ,SUM(CURRT_REPAY_PRIC + CURRT_REPAY_INT + CURRT_REPAY_PNLT + CURRT_REPAY_COMP_INT + CURRT_REPAY_FEE) AS LAST_REPY_AMT
                FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_DTL
               GROUP BY DUBIL_ID,REPAY_DT) M1 --对公贷款交易明细（取上次交易金额）
     ON M1.DUBIL_ID = A.DUBIL_ID
    AND M1.REPAY_DT = B.LAST_REPAY_DT
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 J --表内借据信息表临时表02
     ON J.CUST_ACCT_ID = B.LOAN_REPAY_NUM
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 JJ --表内借据信息表临时表02
     ON JJ.CUST_ACCT_ID = B.LOAN_DISTR_ACCT_NUM
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO L1 --对公贷款借据信息表
     ON L1.DUBIL_ID = A.RELA_DUBIL_ID
    AND L1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP06 TZ --MOD BY LIP 20230828
     ON TZ.DUBIL_ID = A.DUBIL_ID
   --MOD BY YJY 20250103 获取信贷系统无还本续贷为“是”的借据
   LEFT JOIN (SELECT A.OBJECTNO AS DUBIL_ID  --业务流水号
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '60' --标签层级
                 AND A.TAGID = '2024120900000002' --标签编号：是否无还本续贷
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) WHBXD 
     ON WHBXD.DUBIL_ID = A.DUBIL_ID         
   LEFT JOIN RRP_MDL.CODE_MAP TA --码值映射表(贷款业务类别)
     ON TA.SRC_VALUE_CODE = A.STD_PROD_ID
    AND TA.SRC_CLASS_CODE = 'STD0002'
    AND TA.TAR_CLASS_CODE = 'T0001'
    AND TA.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TB --码值映射表(贷款五级分类)
     ON TB.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
    AND TB.SRC_CLASS_CODE = 'CD1032'
    AND TB.TAR_CLASS_CODE = 'D0005'
    AND TB.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TC --码值映射表(还款方式)
     ON TC.SRC_VALUE_CODE = B.INT_SET_WAY_CD
    AND TC.SRC_CLASS_CODE = 'CD2778'
    AND TC.TAR_CLASS_CODE = 'D0103'
    AND TC.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TD --码值映射表(贷款形式)
     ON TD.SRC_VALUE_CODE = A.LOAN_HAPP_TYPE_CD
    AND TD.SRC_CLASS_CODE = 'CD1364'
    AND TD.TAR_CLASS_CODE = 'D0008'
    AND TD.MOD_FLG = 'MDM'
   /*LEFT JOIN RRP_MDL.CODE_MAP TE --码值映射表(放款形式)
     ON TE.SRC_VALUE_CODE = T3.DISTR_MODE_PAY_CD
    AND TE.SRC_CLASS_CODE = 'CD1372'
    AND TE.TAR_CLASS_CODE = 'D0104'
    AND TE.MOD_FLG = 'MDM'*/
   LEFT JOIN DSBR_MODE_TMP TE --受托支付 --ADD BY LIP 20260316 根据信贷反馈，对公的根据支付信息表判断是否受托支付
     ON TE.DUBIL_ID = A.DUBIL_ID
   LEFT JOIN RRP_MDL.CODE_MAP TF --码值映射表(计息形式)
     ON TF.SRC_VALUE_CODE = B.INT_SET_WAY_CD
    AND TF.SRC_CLASS_CODE = 'CD2778'
    AND TF.TAR_CLASS_CODE = 'D0061'
    AND TF.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TG --码值映射表(借据状态)
     ON TG.SRC_VALUE_CODE = A.DUBIL_STATUS_CD
    AND TG.SRC_CLASS_CODE = 'CD2554' --MODIFY BY XIEYUGENG 20221011 数仓码值变化 CD2651->CD2554
    AND TG.TAR_CLASS_CODE = 'D0007'
    AND TG.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TH --码值映射表(账户状态)
     ON TH.SRC_VALUE_CODE = B.LOAN_ACCT_STATUS_CD
    AND TH.SRC_CLASS_CODE = 'CD2554'
    AND TH.TAR_CLASS_CODE = 'Z0018'
    AND TH.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TI --码值映射表(利率种类转码)
     ON TI.SRC_VALUE_CODE = B.INT_RAT_CURVE_TYPE_CD
    AND TI.SRC_CLASS_CODE = 'CD1010'
    AND TI.TAR_CLASS_CODE = 'Z0015'
    AND TI.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTK --码值映射表(利率类型转码)
     ON TTK.SRC_VALUE_CODE = B.INT_RAT_FLOAT_WAY_CD
    AND TTK.SRC_CLASS_CODE = 'CD1016'
    AND TTK.TAR_CLASS_CODE = 'Z0007'
    AND TTK.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TJ --码值映射表(渠道转码)
     ON TJ.SRC_VALUE_CODE = E.TRAST_CHN_CD
    AND TJ.SRC_CLASS_CODE = 'CD2366'
    AND TJ.TAR_CLASS_CODE = 'Z0014'
    AND TJ.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTL --码值映射表(利率调整频率)
     ON TTL.SRC_VALUE_CODE = B.INT_RAT_ADJ_PED_CORP_CD
    AND TTL.SRC_CLASS_CODE = 'CD1041'
    AND TTL.TAR_CLASS_CODE = 'D0105'
    AND TTL.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTM --码值映射表(担保方式转码)
     ON TTM.SRC_VALUE_CODE = A.GUAR_WAY_CD
    AND TTM.SRC_CLASS_CODE = 'CD2656'
    AND TTM.TAR_CLASS_CODE = 'D0002'
    AND TTM.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TXLX --贴息贷款类型 20220921 XUXIAOBIN MODIFY
     ON TXLX.SRC_VALUE_CODE = E.LOAN_FIN_SUPT_WAY_CD
    AND TXLX.SRC_CLASS_CODE = 'D0016'--贴息贷款类型
    AND TXLX.TAR_CLASS_CODE = 'D0016'
    AND TXLX.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE AA --估值报告表
     ON AA.V_TRADE_NO = A.DUBIL_ID
    AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
     ON F.PARTY_ID = A.CUST_ID
    AND F.PHYS_ADDR_TYPE_CD = /*'001001'*/ '06' -- 06-办公营业地址  MOD BY YJY 20260119
    AND F.SRC_SYS_CD = 'CRSS'
    AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息
     ON G.CUST_ID = A.CUST_ID
    AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN CORP_LOAN_REPAY_PLAN_1 I --对公贷款还款计划
     ON I.DUBIL_ID = A.DUBIL_ID
   LEFT JOIN (SELECT DUBIL_ID
                FROM (SELECT B.DUBIL_ID
                             ,ROW_NUMBER() OVER(PARTITION BY B.CUST_ID ORDER BY B.DISTR_DT,B.DUBIL_ID ASC) AS RN
                        FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B
                       WHERE B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
               WHERE RN = 1) H1 --取是否首贷标志 ADD BY 20220824 XUXIAOBIN
     ON H1.DUBIL_ID = A.DUBIL_ID
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00 H2
     ON H2.RCPT_ID = A.DUBIL_ID --取是否首贷日期  MOD BY HULJ20221122
   LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO T18 --行员信息表      ADD BY HULJ20221123
     ON T18.CLERK_ID = A.RGST_TELLER_ID
    AND T18.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T19
     ON T19.TELLER_ID = A.RGST_TELLER_ID
    AND T19.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')   --ADD by hulj20221123
   LEFT JOIN (SELECT T.*
                     ,ROW_NUMBER()OVER(PARTITION BY T.DUEBILLSERIALNO ORDER BY CONTRACTSERIALNO ) RN
                FROM RRP_MDL.O_IOL_ICMS_PUTOUT_ONLINE T
               WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND TRIM(T.DUEBILLSERIALNO) IS NOT NULL) T20 --线上放款申请记录
     ON T20.DUEBILLSERIALNO = A.DUBIL_ID
    AND T20.RN = 1
   LEFT JOIN RRP_MDL.CONFIG_LOAN_PROD CONFIG1 --贷款产品配置表
     ON CONFIG1.STD_PROD_ID = A.STD_PROD_ID
   /*根据与业务确认的口径，imas对公贷款部分取借据发放时的基准利率（信贷登记的就是发放时的基准利率），如果基准利率为0
     则取发放时的LPR，如果取不到发放时的LPR，则取当前最新LPR(垫款和)
     其中，人民币部分：期限：原始到期日-放款日期<5年的就按1年的LPR算 2231，>=5年的按五年的LPR计算2232
     外币的按C0的计算  4000*/
   LEFT JOIN RRP_MDL.O_IML_REF_BASE_RAT_H TBA --基准利率 --ADD BY LIP 20230811
     ON TBA.BASE_RAT_ID = CASE WHEN A.CURR_CD <> 'CNY' THEN '4000'
                               WHEN MONTHS_BETWEEN(CASE WHEN B.RENEW_FLG = '1' THEN A.EXEC_EXP_DT ELSE A.APOT_EXP_DT END,
                                                   CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') IN ('00010101','29991231')
                                                        THEN NULL ELSE B.DISTR_DT END) < 60
                               THEN '2231' --LPR1年
                               ELSE '2232' --LPR5年
                          END
    AND TBA.BASE_RAT_ID IN ('2231','2232','4000')
    AND TBA.CURR_CD = A.CURR_CD
    AND NVL(A.BASE_RAT,0) = 0
    AND TBA.EFFECT_DT <= B.DISTR_DT
    AND TBA.INVALID_DT > B.DISTR_DT
    AND TBA.ID_MARK <> 'D'
    AND TBA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TBA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_REF_BASE_RAT_H TBAB --基准利率 --ADD BY LIP 20230811 取不到起息日时的基准利率时，取最新LPR的
     ON TBAB.BASE_RAT_ID = CASE WHEN MONTHS_BETWEEN(CASE WHEN B.RENEW_FLG = '1' THEN A.EXEC_EXP_DT ELSE A.APOT_EXP_DT END,
                                                    CASE WHEN TO_CHAR(B.DISTR_DT,'YYYYMMDD') IN ('00010101','29991231')
                                                         THEN NULL ELSE B.DISTR_DT END) < 60
                                THEN '2231' --LPR1年
                                ELSE '2232' --LPR5年
                            END
    AND TBAB.BASE_RAT_ID IN ('2231','2232')
    AND TBAB.CURR_CD = 'CNY'
    AND NVL(A.BASE_RAT,0) = 0 --信贷基准利率为0时
    AND NVL(TBA.BASE_RAT,0) = 0 --起息日时的基准利率为0时
    AND TBAB.EFFECT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TBAB.INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TBAB.ID_MARK <> 'D'
    AND TBAB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TBAB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   --ADD BY YJY 20250303  取重组贷款标识
   /*LEFT JOIN (SELECT A.OBJECTTYPE      --关联类型
                     ,A.OBJECTNO       --借据号
                     ,B.SERIALNO      --申请流水号
                     ,B.APPROVESTATUS --审批状态
                     ,B.INPUTUSERID   --登记人
                     ,B.INPUTORGID    --登记机构
                     ,B.INPUTDATE     --登记日期
                     ,B.CUSTOMERID    --客户号
                     ,B.CUSTOMERNAME  --客户名称
              FROM RRP_MDL.O_IOL_ICMS_LOAN_REBUILD_RELATIVE A --贷款重组关联表
             INNER JOIN RRP_MDL.O_IOL_ICMS_LOAN_REBUILD B  --贷款重组
                ON B.SERIALNO = A.SERIALNO
               AND B.APPROVESTATUS = 'Finished' --审批状态 已完成
               AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
             WHERE A.OBJECTTYPE = 'RestoolDuebill'
               AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ) CZ
     ON CZ.OBJECTNO = A.DUBIL_ID*/  --MOD BY YJY 20251226 王玲确认因信贷系统优化了发生额类型，这部分取数逻辑不准确
   --ADD BY YJY 20260311 取重组贷款标识
   LEFT JOIN ( SELECT BP.SERIALNO          AS SERIALNO -- 续期出账
                     ,BE.RELATIVEDUEBILLNO AS RELATIVEDUEBILLNO -- 借据号
                     ,BE.EXTENDEFFECTDATE  AS EXTENDEFFECTDATE -- 展期生效日
                     ,BP.RENEWALTYPE       AS RENEWALTYPE --重组类型
                 FROM RRP_MDL.O_IOL_ICMS_BUSINESS_PUTOUT BP -- 出账信息表出账信息表
                 LEFT JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_EXTENSION BE -- 展期信息表展期信息表
                   ON BE.PUTOUTNO = BP.SERIALNO
                  AND BE.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND BE.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
                INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO EI--对公账户信息表
                   ON EI.DUBIL_NUM = BE.RELATIVEDUEBILLNO
                  AND EI.RENEW_FLG = '1' --展期标志 
                  AND EI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE BP.OCCURTYPE = '0209' --发生类型：0209-重组
                  AND BP.RENEWALTYPE IN ('VAL','REP') --展期类型: VAL-续期、REP-调整还款计划
                  AND BP.APPROVESTATUS = 'Finished'
                  AND BP.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND BP.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
                  AND BE.EXTENDEFFECTDATE >= TO_DATE('20260109', 'YYYYMMDD') )CZ
     ON CZ.RELATIVEDUEBILLNO = A.DUBIL_ID
   --ADD BY YJY 20260319 取重组贷款标识,增加判断对公信贷重组贷款的逻辑，信贷系统未对重组类型-调整还款计划的合同进行改造
   LEFT JOIN ( SELECT BP.DUEBILLSERIALNO --借据号
                 FROM RRP_MDL.O_IOL_ICMS_BUSINESS_CONTRACT EC
                INNER JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_CONTRACT BC
                   ON EC.SERIALNO = BC.RELACONTRACTNO
                  AND BC.BUSINESSFLAG = '2'
                  AND BC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')  
                INNER JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_DUEBILL BD 
                   ON BC.SERIALNO = BD.CONTRACTSERIALNO
                  AND BD.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BD.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                INNER JOIN RRP_MDL.O_IOL_ICMS_BUSINESS_PUTOUT BP 
                   ON BD.PUTOUTSERIALNO = BP.SERIALNO  
                  AND BP.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND BP.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE EC.RENEWALTYPE = 'REP' 
                  AND EC.BUSINESSFLAG = '1'
                  AND EC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND EC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') )CZ1
     ON CZ1.DUEBILLSERIALNO = A.DUBIL_ID
   --ADD BY YJY 20260312 取并购贷款
   LEFT JOIN (  SELECT A.OBJECTNO AS CONT_ID  --业务合同号
                      ,A.TAGID    AS TAGID    --标签编号
                      ,A.TAGVALUE AS TAGVALUE --标签值
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '50' --标签层级 业务合同
                 AND A.TAGID IN ( '2026031090000004'  --是否境外并购贷款
                                 ,'2026031090000005') --并购贷款类型
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') ) BG
     ON BG.CONT_ID = A.CONT_ID
   --ADD BY YJY 20260312 是否退役军人创办企业
   LEFT JOIN ( SELECT A.OBJECTNO AS CUST_ID  --客户号
                     ,A.TAGVALUE AS TAGVALUE --标签值
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '10' --标签层级 客户编号
                 AND A.TAGID = '2026030990000004' --是否退役军人创办企业
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') ) JR
     ON JR.CUST_ID = A.CUST_ID
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP08 T1 --福费廷交易对手信息 --ADD BY LIP 20251222
     ON T1.DUBIL_NUM = A.DUBIL_ID
    AND T1.RM = 1
  WHERE (A.STD_PROD_ID LIKE '2%' OR A.STD_PROD_ID LIKE '6020%' )
    AND A.DUBIL_ID IS NOT NULL
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--零售贷款部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ACC_ID                      --账户编号
    ,RCPT_ID                     --借据编号
    ,CONT_ID                     --合同编号
    ,BILL_NO                     --票据号码
    ,COOP_AGRT_ID                --合作协议编号
    ,CUST_ID                     --客户编号
    ,ORG_ID                      --机构编号
    ,SUBJ_ID                     --科目编号
    ,LOAN_STD_PROD_ID            --贷款标准产品编号
    ,LOAN_STD_PROD_NM            --贷款标准产品名称
    ,LOAN_PROD_ID                --贷款产品编号
    ,LOAN_PROD_NM                --贷款产品名称
    ,LOAN_BIZ_TYP                --贷款业务类型
    ,CUR                         --币种
    ,LOAN_AMT                    --借款金额
    ,LOAN_BAL                    --贷款余额
    ,INT_ADJ                     --利息调整
    ,FAIR_VAL_CHG                --公允价值变动
    ,OVD_PRIN_BAL                --逾期本金余额
    ,IN_INT_OVD_BAL              --表内欠息余额
    ,OUT_INT_OVD_BAL             --表外欠息余额
    ,LOAN_ACT_DSTR_DT            --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT            --贷款原始到期日期
    ,LOAN_ACT_EXP_DT             --贷款实际到期日期
    ,ACT_END_DT                  --实际终止日期
    ,LAST_REPY_DT                --上次还款日期
    ,LAST_REPY_AMT               --上次还款金额
    ,VAL_DT                      --起息日期
    ,OPEN_ACC_DT                 --开户日期
    ,CNL_ACC_DT                  --销户日期
    ,PRIN_OVD_DT                 --本金逾期日期
    ,INT_OVD_DT                  --利息逾期日期
    ,OVD_DAYS                    --逾期天数
    ,OVD_TYP                     --逾期类型
    ,LOAN_USEAGE                 --贷款用途
    ,LVL5_CL                     --五级分类
    ,GUA_MODE                    --担保方式
    ,LOAN_DIR_RGN                --贷款投向地区
    ,LOAN_DIR_IDY                --贷款投向行业
    ,SYN_LOAN_FLG                --银团贷款标志
    ,PROJ_LOAN_FLG               --项目贷款标志
    ,IDY_STRU_ADJ_TYP            --产业结构调整类型
    ,IDY_TRNST_UPG_FLG           --工业转型升级标志
    ,STRTG_EMER_IDY_TYP          --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
    ,AGR_REL_LOAN_FLG            --涉农贷款标志
    ,RL_EST_LOAN_FLG             --房地产贷款标志
    ,IALL_LOAN_FLG               --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP            --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN               --贷款办理渠道
    ,NET_LOAN_FLG                --互联网贷款标志
    ,NET_LOAN_PROD_TYP           --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
    ,REPY_MODE                   --还款方式
    ,LOAN_FRM                    --贷款形式
    ,RCMM_LOAN_FLG               --重组贷款标识
    ,ADJ_BAD_FLG                 --下调为不良标志
    ,ALDY_RCMM_FLG               --曾重组标志
    ,CTON_PRD_LOAN_FLG           --缩期贷款标志
    ,CASH_TRF_FLG                --现转标志
    ,FST_LOAN_FLG                --首贷户贷款标志
    ,FIRST_LOAN_FLG              --首次贷款标志
    ,PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE          --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
    ,RATE_RE_PRC_DT              --利率重新定价日期
    ,RATE_FLT_FREQ               --利率浮动频率
    ,RATE_TYP                    --利率类型
    ,AST_SCRTZ_PROD_ID           --资产证券化产品编号
    ,EXEC_RATE                   --执行利率
    ,BASE_RATE                   --基准利率
    ,CNTR_GUA_LOAN_FLG           --反担保贷款标志
    ,RATE_FLT_VAL                --利率浮动值
    ,PRC_BASE_TYP                --定价基准类型
    ,TOT_PRD_NUM                 --总期数
    ,CURR_PRD                    --当前期数
    ,CUM_DEBT_PRD_NUM            --累计欠款期数
    ,CNU_DEBT_PRD_NUM            --连续欠款期数
    ,EXTN_CNT                    --展期次数
    ,DSBR_MODE                   --放款方式
    ,INT_CALC_MODE               --计息方式
    ,MRGN_PCT                    --保证金比例
    ,MRGN_CUR                    --保证金币种
    ,MRGN                        --保证金
    ,MRGN_ACC                    --保证金账号
    ,LOAN_OFR_NO                 --信贷员工号
    ,ACCRD_INT                   --应计利息
    ,PRO_IMPT                    --减值准备
    ,COM_PRO                     --一般准备
    ,SPCL_PRO                    --专项准备
    ,ESP_PRO                     --特别准备
    ,SPCL_LOAN_FLG               --专项贷款标志
    ,ORIG_RCPT_NO                --原借据号
    ,FND_PCT                     --出资比例
    ,ETR_ACC                     --入账账号
    ,ETR_ACC_NM                  --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
    ,REPY_ACC                    --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
    ,RCPT_STAT                   --借据状态
    ,ACC_STAT                    --账户状态
    ,REV_LOAN_FLG                --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
    ,BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                --境内外标志
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,LMT_CONT_ID                 --额度合同编号
    ,GXH_PAY_TYPE                --还款方式
    ,GXH_PAY_FREQ                --还款频度
    ,ASSET_TRAN_DT               --资产转让日期
    ,LOAN_DIR_BIO_FLG            --贷款投向境内外标识
    ,OVD_INT_BAL                 --逾期利息金额
    ,LOAN_CRDT_LMT_TOT           --单户授信总额度
    ,REFAC_FLG                   --支小再贷款标识
    ,BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD               --贷款形态代码
    ,OPER_ORG_ID                 --经办机构编号 MOD BY HULJ 20221122
    ,OPER_TELLER_ID              --经办柜员编号 MOD BY HULJ 20221122
    ,LOAN_ACT_FIRST_DT           --本行首贷日期 MOD BY HULJ 20221122
    ,RENEW_EXP_DAY               --展期到期日期 MOD BY HULJ 20221122
    ,LOAN_MGR_ID                 --借据主办客户经理号 --ADD BY LIP 20251218
    ,LOAN_TELLER_ID              --借据主办柜员号 --ADD BY LIP 20251218
    ,CNCL_DT                     --核销日期   ADD BY MW 20221123
    ,FIXED_INT_MARK              --利率是否固定
    ,IN_BS_INT                   --表内利息
    ,OFF_BS_INT                  --表外利息
    ,DISTR_AMT                   --放款金额
    ,DISTR_DT                    --放款日期
    ,EAST_FLG                    --EAST口径标识
    ,CTR_NT_ID                   --成交单编号
    ,RECVBL_PNLT                 --应收罚息
    ,COLL_PNLT                   --催收罚息
    ,RECVBL_COMP_INT             --应收复息
    ,RECVBL_INT_SUB              --应收贴息
    ,RECVBL_FINE                 --应收罚金
    ,RECVBL_OVER_INT             --应收欠息
    ,COLL_OVER_INT               --催收欠息
    ,LOAN_USEAGE_SUB_CL          --贷款用途细类
    ,CUST_CHAR                   --客户性质
    ,OUT_ACCT_FLOW_NUM           --出账流水号
    ,ICMS_CUST_ID                --信贷客户编号
    ,BASE_RAT_IMAS               --基准利率IMAS --ADD BY LIP 20230810
    ,ABS_FLG                     --资产证券化标志
    ,ASSET_TRAN_FLG              --资产转让标志
    ,REGROUP_LOAN_FLG            --重组贷款标志  ADD BY HULJ20231228
    ,REGROUP_LOAN_TYPE_CD        --重组贷款类型代码 ADD BY HULJ20231228
    ,PROVI_FOR_AGED_PROPERTY_FLG --养老产业标志   --ADD BY YJY 20240507
    ,PAYOFF_DT                   --结清日期       -- ADD  BY YJY 20241022
    ,SUIT_FEE_BAL                --诉讼费余额     --ADD BY YJY 20241217
    ,ISWHITE_FLG                 --白户标志       --ADD BY LAL 20250904
    ,GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
    ,YBT_FLG                     --一表通口径标识 --ADD BY PSF 20250916
    ,ACCT_MODIF_CATE_CD          --账户变更类别代码 --ADD BY LYH 20260127
    ,SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
    )
    WITH CL_INVOICE_OD_DETAIL AS (
  SELECT OV.ACCT_ID
         ,OV.CURR_PD
         ,SUM(CASE WHEN OV.DOC_BAL > 0 AND OV.DOC_FULL_AMT_CALLBK_FLG = '0' THEN 1 ELSE 0 END) AS SFHK --是否还款
         --MOD BY 20240308 判断逾期利息、罚息、复利有没有逾期
         ,SUM(CASE WHEN OV.ISS_AMT > 0 AND (OV.FINAL_STL_DT > OV.GRACE_DT OR OV.FINAL_STL_DT = TO_DATE('00010101','YYYYMMDD'))
                   THEN 1 ELSE 0 END)  AS SFYQ --是否逾期
    FROM RRP_MDL.O_IML_EVT_PNLT_COMP_INT_NOMAL_REPAY_DTL OV   --罚息复利正常还款明细
   WHERE OV.GRACE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')  --没到宽限期的算正常，不算逾期
     AND OV.GRACE_DT <> TO_DATE('00010101','YYYYMMDD')
     AND OV.ISS_FLG = '1'
     AND OV.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY OV.ACCT_ID,OV.CURR_PD)
  ,RETL_LOAN_REPAY_PLAN AS (
  SELECT /*+MATERIALIZE*/N.ACCT_ID,N.DUBIL_ID,N.TOT_PERDS,N.REPAY_PERDS,N.REPAYBL_DT,N.ETL_DT,MAX(N.VALUE_DT) AS VALUE_DT
         --MOD BY LIP 20231107 数仓的逾期标志是指现在是否仍然逾期，EAST需要用历史是否逾期标志
         ,SUM(CASE WHEN N.PD_H_OVDUE_FLG = '1' THEN 1 ELSE 0 END) AS OVDUE_FLG --逾期标志为是 0为否
         ,CASE WHEN MIN(N.REPAY_FLG) = '0' THEN 0 ELSE 1 END AS REPAY_FLG  --N.REPAY_FLG = '0'  --未偿还
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_PLAN N  --零售贷款还款计划
   WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY N.ACCT_ID,N.DUBIL_ID,N.TOT_PERDS,N.REPAY_PERDS,N.REPAYBL_DT,N.ETL_DT)
  ,RETL_LOAN_REPAY_PLAN_1 AS(
  SELECT /*+MATERIALIZE*/N.DUBIL_ID
         ,MAX(N.TOT_PERDS) AS TOT_PERDS
         ,MAX(N.REPAY_PERDS) AS REPAY_PERDS
         ,MIN(CASE WHEN N.REPAYBL_DT > TO_DATE(V_P_DATE,'YYYYMMDD') THEN N.REPAY_PERDS ELSE N.TOT_PERDS END) AS CURR_PERDS
         ,SUM(CASE WHEN (N.OVDUE_FLG >= 1 AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') AND N.REPAY_FLG = 0) --未偿还
                     OR (CL.SFHK > 0) --欠息是否偿还
                   THEN 1
                   ELSE 0 END) AS LXQKQS --连续欠款期数
         --MOD BY 20240308 增加逾期利息、复息、罚息是否逾期的判断
         ,SUM(CASE WHEN N.OVDUE_FLG >= 1 OR (CL.SFYQ > 0) THEN 1 ELSE 0 END) AS LJQKQS --累计欠款期数
    FROM RETL_LOAN_REPAY_PLAN N --对公贷款还款计划
    LEFT JOIN CL_INVOICE_OD_DETAIL CL
      ON CL.ACCT_ID = N.ACCT_ID
     AND CL.CURR_PD = N.REPAY_PERDS
   WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY N.DUBIL_ID)
  ,CORP_CUST AS (
  SELECT TRIM(T.PBC_PAY_BANK_NO) AS SYS_PRTCPTR_BIGAMT_BANK_NO--系统参与者大额行号
         ,TRIM(T.CUST_NAME)      AS SYS_PRTCPTR_BIGAMT_BANK_NAME--系统参与者大额行名
         ,ROW_NUMBER() OVER(PARTITION BY TRIM(T.CUST_NAME) ORDER BY TRIM(CUST_NAME) NULLS LAST) RN
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO T   --对公客户基本信息
   WHERE TRIM(T.PBC_PAY_BANK_NO) IS NOT NULL
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  --ADD BY LYH 20260127
  ,CL_AMEND AS (
  SELECT /*+ MATERIALIZE */
         T.*,ROW_NUMBER() OVER(PARTITION BY T.MODIF_CONTENT_KEY_VAL ORDER BY T.MODIF_DT DESC NULLS LAST,T.TRAN_TM DESC NULLS LAST) RN
    FROM RRP_MDL.O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL T
   WHERE T.ACCT_MODIF_CATE_CD IN ('EXTENSION', 'MATS') --延期：EXTENSION，缩期：MATS
     AND T.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                            AS DATA_DT                    --数据日期
        ,A.LP_ID                                                 AS LGL_REP_ID                 --法人编号
        ,A.ACCT_ID                                               AS ACC_ID                     --账户编号
        ,A.DUBIL_NUM                                             AS RCPT_ID                    --借据编号
        ,A.CONT_ID                                               AS CONT_ID                    --合同编号
        ,NULL                                                    AS BILL_NO                    --票据号码
        ,NULL                                                    AS COOP_AGRT_ID               --合作协议编号  MODIFY BY MW 20221228从合同表取，借据表不存值
        ,A.CUST_ID                                               AS CUST_ID                    --客户编号
        ,A.ACCT_INSTIT_ID                                        AS ORG_ID                     --机构编号
        ,A.SUBJ_ID                                               AS SUBJ_ID                    --科目编号
        ,A.STD_PROD_ID                                           AS LOAN_STD_PROD_ID           --贷款标准产品编号
        ,C.PROD_NAME                                             AS LOAN_STD_PROD_NM           --贷款标准产品名称
        ,A.STD_PROD_ID                                           AS LOAN_PROD_ID               --贷款产品编号
        ,C.PROD_NAME                                             AS LOAN_PROD_NM               --贷款产品名称
        ,CASE WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100101' THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD = '100102' THEN '010302' --房屋装修贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0103%' AND TA.BORW_USAGE_TYPE_CD IN ('100109') THEN '010301' --个人汽车贷款
              WHEN TTA.TAR_VALUE_CODE LIKE '0102%' AND TA.BORW_USAGE_TYPE_CD IN ('100201') THEN '010202' --商用车贷款
              WHEN A.STD_PROD_ID IN ('201030200001','201030200002','201030200003') THEN '010101' --个人住房按揭商业贷款
              WHEN A.STD_PROD_ID IN ('201030200001','201030200002') AND TA.BORW_USAGE_TYPE_CD <> '100301'
              THEN '010101' --个人中长期住房贷款(个人住房按揭商业贷款)
              WHEN A.STD_PROD_ID IN ('201030100001','201030100002') AND TA.BORW_USAGE_TYPE_CD = '100301'
              THEN '010201'              --个人中长期住房贷款(商业用房贷款)
              ELSE NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID)
          END                                                   AS LOAN_BIZ_TYP               --贷款业务类型
        ,A.CURR_CD                                              AS CUR                        --币种
        ,A.DUBIL_AMT                                            AS LOAN_AMT                   --借款金额
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE A.CURRT_BAL
          END                                                   AS LOAN_BAL                   --贷款余额
        ,0                                                      AS INT_ADJ                    --利息调整
        ,0                                                      AS FAIR_VAL_CHG               --公允价值变动
        ,CASE WHEN A.WRT_OFF_FLG = '1'
              THEN 0
              ELSE NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0)
          END                                                   AS OVD_PRIN_BAL               --逾期本金余额
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              --应收欠息(RECVBL_OVER_INT),应收罚息(RECVBL_PNLT),应收复息(RECVBL_COMP_INT)相加 --MOD BY LIP 20230527
              ELSE NVL(A.RECVBL_OVER_INT,0) + NVL(A.RECVBL_PNLT,0) + NVL(A.RECVBL_COMP_INT,0)
          END                                                   AS IN_INT_OVD_BAL             --表内欠息余额
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              --催收欠息(COLL_OVER_INT),催收罚息(COLL_PNLT) --MOD BY LIP 20230527
              ELSE NVL(A.COLL_OVER_INT,0) + NVL(A.COLL_PNLT,0)
          END                                                    AS OUT_INT_OVD_BAL            --表外欠息余额
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                          AS LOAN_ACT_DSTR_DT           --贷款实际发放日期
        ,TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD')                       AS LOAN_ORIG_EXP_DT           --贷款原始到期日期 mod by hulj20231207
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                            AS LOAN_ACT_EXP_DT            --贷款实际到期日期
        ,CASE WHEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101')
               AND D.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
              WHEN TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') NOT IN ('00010101')
               AND A.ASSET_TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD') --资产转让日期
              WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                                    AS ACT_END_DT                 --实际终止日期
        ,TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')                     AS LAST_REPY_DT               --上次还款日期
        ,NULL                                                    AS LAST_REPY_AMT              --上次还款金额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                          AS VAL_DT                     --起息日期
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')                      AS OPEN_ACC_DT                 --开户日期
        ,CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231')
              THEN NULL
              ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
          END                                                    AS CNL_ACC_DT                 --销户日期
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.PRIC_OVDUE_DAYS,'YYYYMMDD')
          END                                                    AS PRIN_OVD_DT                --本金逾期日期
        ,CASE WHEN A.INT_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.INT_OVDUE_DAYS,'YYYYMMDD')
          END                                                    AS INT_OVD_DT                 --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)            AS OVD_DAYS                   --逾期天数
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
              WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
              WHEN A.PRIC_OVDUE_DAYS = 0 AND A.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
              ELSE NULL
          END                                                    AS OVD_TYP                     --逾期类型  --MODIFY BY HYF 20241210
        ,PUB.CD_DESCB                                            AS LOAN_USEAGE                 --贷款用途  --MODIFY BY MW 20221220 直取数仓码值表，不做额外转码
        ,TTC.TAR_VALUE_CODE                                      AS LVL5_CL                     --五级分类
        ,TTM.TAR_VALUE_CODE                                      AS GUA_MODE                    --担保方式
        --MOD BY LIP 20230531 根据张家伟口径：自营按照贷款业务所在的机构所在地
        ,ORG_DQ.COUNTY_CD                                        AS LOAN_DIR_RGN                --贷款投向地区
        ,CASE WHEN B.DIR_INDUS_CD = '-'
              THEN 'Z'
              ELSE NVL(B.DIR_INDUS_CD,'Z')
          END                                                    AS LOAN_DIR_IDY                --贷款投向行业
        ,NULL                                                    AS SYN_LOAN_FLG                --银团贷款标志
        ,CONFIG1.PROJ_LOAN_FLG                                   AS PROJ_LOAN_FLG               --项目贷款标志
        ,NULL                                                    AS IDY_STRU_ADJ_TYP            --产业结构调整类型
        ,NULL                                                    AS IDY_TRNST_UPG_FLG           --工业转型升级标志
        ,NULL                                                    AS STRTG_EMER_IDY_TYP          --战略新兴产业类型
        ,CASE WHEN TA.COPRATOR_ID IN ('2290000001') THEN 'Y' --深圳微众税银信息服务有限公司
              ELSE NVL(CONFIG1.BANK_TAX_COOP_LOAN_FLG,'N')
          END                                                    AS BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
        ,CASE WHEN (F.FARM_FLG = '1') THEN 'Y'
              ELSE 'N'
         END                                                     AS AGR_REL_LOAN_FLG           --涉农贷款标志
        ,NVL(CONFIG1.RL_EST_LOAN_FLG,'N')                        AS RL_EST_LOAN_FLG            --房地产贷款标志
        ,NULL                                                    AS IALL_LOAN_FLG              --投贷联动贷款标志
        ,NULL                                                    AS OV_SEA_MRG_LOAN_FLG        --境外并购贷款标志
        --MOD BY LIP 20230802 修改零售的绿色贷款用途分类 --20 新能源 10 传统动力
        ,DECODE(TA.VEHIC_TYPE_CD,'20','50',TA.VEHIC_TYPE_CD)     AS GRN_LOAN_USEAGE_CL         --绿色贷款用途分类
        ,NULL                                                    AS ENT_GUA_LOAN_TYP           --创业担保贷款类型
        ,NULL                                                    AS CAMPUS_CNSMP_LOAN_FLG      --校园消费贷款标志
        ,NULL                                                    AS LCL_GOVFINPLTF_LOAN_FLG    --地方政府融资平台贷款标志
        ,NULL                                                    AS LAND_THIRDPARTY_LOAN_TYP   --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                                    AS FARMER_THIRDPARTY_LOAN_TY  --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                                    AS POV_ALLE_REC_FLG           --未脱贫建档立卡户贷款标志
        ,NVL(TJ.TAR_VALUE_CODE,M.CHN_ID)                         AS LOAN_HDL_CHAN              --贷款办理渠道
        /*,CASE WHEN B.STD_PROD_ID IN ('202010200005','202020200002','202010200008','202010200003',
           '202020200006','202020200005','202010200004','202020200003')
              THEN 'Y'
              ELSE 'N'
          END                                                    NET_LOAN_FLG               --互联网贷款标志*/
        /*,NVL(CONFIG1.NET_LOAN_FLG,'N')*/
        --MOD BY YJY 20241216 优先判断尽调标志为否的则为互联网贷款业务
        ,CASE --WHEN B.STD_PROD_ID IN ('201010300040','201020100060') AND B.DUE_DILIGENCE_FLG <> '1' THEN 'Y' --201010300040华兴易贷（信用）201020100060华兴好易贷（经营-信用） --mod by yjy 20250805
              WHEN B.STD_PROD_ID IN ('201010300040','201020100060') AND B.OUTLINE_VRIF_IDTI_FLG <> '1' THEN 'Y' --mod BY YJY 20260226 判断是否线下核身为否的则为互联网
              WHEN B.STD_PROD_ID IN ('201010300035',/*'201010300041',*/'201020100059') THEN 'Y' --201010300035华兴易贷（担保）201010300041华兴好易贷（华强）201020100059华兴好易贷（经营-担保）--MOD BY YJY 20250103 默认互联网贷款
              WHEN B.STD_PROD_ID IN ('201020100062','201020100061'
                                     ,'201020100014','201020100024','201020100051','201020100052') 
               --ADD BY YJY  201020100014、201020100024、201020100051、201020100052新增互联贷款业务标签，参考201020100062 饲料e贷-海大集团
               AND HD.DUBIL_ID IS NOT NULL THEN 'Y' --饲料e贷-海大集团\兴采贷 ADD BY YJY 20250717 关联标签表判断是否互联网业务
              WHEN B.STD_PROD_ID = '202010200012' THEN 'Y' --202010200012-360借条 默认互联网贷款 ADD BY YJY 20250826
         ELSE NVL(CONFIG1.NET_LOAN_FLG,'N')
         END                                                     AS NET_LOAN_FLG               --互联网贷款标志
        --MODIFY BY WEIYONGZHAO 20230523 关联G09静态表取合作方式
        ,CASE WHEN HZF.HZFS = '01' THEN '1' --联合贷
              WHEN HZF.HZFS = '02' THEN '2' --助贷
              WHEN HZF.HZFS = '03' THEN '3' --自营
          END                                                    AS NET_LOAN_PROD_TYP          --网贷产品类别
        ,NULL                                                    AS CR_CRD_BIZ_OD_TYP          --类信用卡业务透支类型
        ,CASE WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '1M' THEN '01' --按月
              WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '3M' THEN '02' --按季
              WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '6M' THEN '03' --按半年
              WHEN A.REPAY_PED||A.REPAY_PED_CORP_CD = '12M' THEN '04' --按年
              ELSE TTE.TAR_VALUE_CODE
          END                                                    AS REPY_MODE                  --还款方式
        --MOD BY 20240319 增加无还本续贷（参考6301口径）和借新还旧的码值
        ,CASE WHEN TA.LOAN_HAPP_TYPE_CD  IN (/*'0102',*/'0210') THEN '05' --无还本续贷 --MOD BY YJY 20260104 修改无还本续贷的映射码值
              --MOD BY YJY 20260203 张家伟确认个人无还本续贷原本是按照发生类型为”原额度续作“进行判断，后续个人无还本续贷的判断逻辑需要改为按照信贷系统的“发生类型为无还本续贷”进行判断
              WHEN TA.LOAN_HAPP_TYPE_CD = '0202' THEN '03' --借新还旧
              ELSE '01'
          END                                                    AS LOAN_FRM                   --贷款形式   --20221121  参考east5.0口径修改 LHQ
        /*,CASE WHEN TA.LOAN_HAPP_TYPE_CD IN ('0201','0204','0202')\*0201展期 0204债务重组 0202借新还旧*\
              THEN 'Y'
              ELSE 'N'
          END                                                    AS RCMM_LOAN_FLG              --重组贷款标识*/
        --UPDATE BY YJY 20260413 与REGROUP_LOAN_FLG取值保持一致
        ,CASE WHEN B.REGROUP_LOAN_FLG = '1' THEN 'Y'
              ELSE 'N'
          END                                                    AS RCMM_LOAN_FLG              --重组贷款标识
        ,NULL                                                    AS ADJ_BAD_FLG                --下调为不良标志
        ,NULL                                                    AS ALDY_RCMM_FLG              --曾重组标志
        ,NULL                                                    AS CTON_PRD_LOAN_FLG          --缩期贷款标志
        ,NULL                                                    AS CASH_TRF_FLG               --现转标志
        ,DECODE(H1.RCPT_ID, NULL,'N', 'Y')                       AS FST_LOAN_FLG               --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H1.RCPT_ID, NULL,'N', 'Y')                       AS FIRST_LOAN_FLG             --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,NULL                                                    AS PBOC_GRN_LOAN_FLG          --PBOC绿色贷款标志
        ,'N'                                                     AS CBRC_GRN_LOAN_FLG          --CBRC绿色贷款标志
        ,NULL                                                    AS CNSMP_SCN_LOAN_FLG         --消费场景贷款标志
        ,NULL                                                    AS LOAN_FINC_SPT_MODE         --贷款财政扶持方式
        ,CASE WHEN AD.POVERTY_LOAN_FLG LIKE '%返贫%'
                OR AD.POVERTY_LOAN_FLG LIKE '%未脱贫%' THEN 'N'
              WHEN AD.POVERTY_LOAN_FLG LIKE '%已脱贫%'
                OR AD.POVERTY_LOAN_FLG = '脱贫' THEN 'Y'
              WHEN A.DISTR_DT > TO_DATE('20211231','YYYYMMDD')
               AND AC.CUST_ID IS NOT NULL THEN 'Y'
              ELSE NULL
          END                                                    AS ACURT_POV_ALLE_LOAN_FLG    --精准扶贫贷款标志
        ,CASE WHEN A.NEXT_INT_RAT_ADJ_DT = DATE'0001-01-01' THEN NULL
              ELSE TO_CHAR(A.NEXT_INT_RAT_ADJ_DT,'YYYYMMDD')
          END                                                    AS RATE_RE_PRC_DT              --利率重新定价日期 20221109 XUXIAOBIN MODIFY
        ,CASE WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1D' THEN '01'---按日
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD IN ('7D','1W') THEN '02'--按周
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1M' THEN '03'---按月
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '3M' THEN '04'--按季
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '6M' THEN '05'--按半年
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '12M' THEN '06'--按年
              ELSE '99'
          END                                                    AS RATE_FLT_FREQ              --利率浮动频率
        ,TTK.TAR_VALUE_CODE                                      AS RATE_TYP                   --利率类型
        ,NULL                                                    AS AST_SCRTZ_PROD_ID          --资产证券化产品编号
        ,A.EXEC_INT_RAT                                          AS EXEC_RATE                  --执行利率
        ,A.BASE_RAT                                              AS BASE_RATE                  --基准利率
        ,NULL                                                    AS CNTR_GUA_LOAN_FLG          --反担保贷款标志
        ,B.INT_RAT_FLO_VAL                                       AS RATE_FLT_VAL               --利率浮动值
        ,CASE WHEN A.BASE_RAT_ID IN ('2231','2232') THEN 'TR07'  --MODIFY  CCH  20221025  根据新监管码值，2231、2232对应报表的LPR
              ELSE TI.TAR_VALUE_CODE
          END                                                    AS PRC_BASE_TYP               --定价基准类型
        --因核心的当前期数字段，客户还完最后一期时，账户表的当前期数自动+1，会比还款计划中的总期数大1，所以加上总期数=0的判断
        ,CASE WHEN (NVL(A.TOT_PERDS,0) = 0 AND A.TOT_PERDS < A.CURR_ISSUE_PERDS) --因贷款产品跑批问题，部分借据的还款计划被清掉了
              THEN A.CURR_ISSUE_PERDS
              ELSE A.TOT_PERDS
          END                                                    AS TOT_PRD_NUM                --总期数
        --MOD BY LIP 20231013 调整为处于还款计划中的哪一期
        --,NVL(DD.CURR_PERDS,A.CURR_ISSUE_PERDS)                   AS CURR_PRD                   --当前期数
        --MOD BY LIP 20251107 一表通沟通后调整当前期数的取数口径
        ,CASE WHEN A.DUBIL_NUM = 'R20230303302131295763' AND A.TOT_PERDS < A.CURR_ISSUE_PERDS
              THEN NVL(A.CURR_ISSUE_PERDS,0) --这笔借据有点问题，核心20251121版本调整
              WHEN A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD') + 1 AND A.LOAN_ACCT_STATUS_CD = 'A'
              THEN NVL(A.CURR_ISSUE_PERDS,0) --借据到期日大于当前日期的时候，且状态为正常的，就取借据表的当前期次吗
              ELSE NVL(A.TOT_PERDS,0)
          END                                                              AS CURR_PRD                   --当前期数
        ,NVL(DD.LJQKQS,0)                                        AS CUM_DEBT_PRD_NUM           --累计欠款期数
        ,NVL(DD.LXQKQS,0)                                        AS CNU_DEBT_PRD_NUM           --连续欠款期数
        ,NVL(A.RENEW_CNT,0)                                      AS EXTN_CNT                   --展期次数
        ,NVL(TTG.TAR_VALUE_CODE,'01')                            AS DSBR_MODE                  --放款方式
        ,NVL(TRIM(TTH.TAR_VALUE_CODE),'9901')                    AS INT_CALC_MODE              --计息方式  --modify by tangan at 20210103 空处理，空默认为9901-其他-未知
        ,NULL                                                    AS MRGN_PCT                   --保证金比例
        ,NULL                                                    AS MRGN_CUR                   --保证金币种
        ,NULL                                                    AS MRGN                       --保证金
        ,NULL                                                    AS MRGN_ACC                   --保证金账号
        ,B.CUST_MGR_ID                                           AS LOAN_OFR_NO                --信贷员工号
        ,A.CURRT_ACRU_INT                                        AS ACCRD_INT                  --应计利息
        ,NULL                                                    AS PRO_IMPT                   --减值准备
        ,NULL                                                    AS COM_PRO                    --一般准备
        ,NULL                                                    AS SPCL_PRO                   --专项准备
        ,NULL                                                    AS ESP_PRO                    --特别准备
        ,NULL                                                    AS SPCL_LOAN_FLG              --专项贷款标志
        ,NULL                                                    AS ORIG_RCPT_NO               --原借据号
        ,100                                                     AS FND_PCT                    --出资比例
        ,CASE WHEN A.STD_PROD_ID IN ('202020200005','202020200006')
               AND TRIM(TA.ENTER_ACCT_ID) IS NOT NULL --网商小贷 取合同栏位的账号
              THEN TA.ENTER_ACCT_ID
              WHEN A.STD_PROD_ID IN ('202020200002','202010200005')
               AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NUM
              WHEN A.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
               AND TRIM(T1.RECVBL_BANK_CARD_CARD_NO) IS NOT NULL --华兴易贷 --MOD BY LIP 20250310
              THEN TRIM(T1.RECVBL_BANK_CARD_CARD_NO)
              ELSE A.LOAN_DISTR_ACCT_NUM
          END                                                    AS ETR_ACC                    --入账账号
        ,CASE WHEN A.STD_PROD_ID IN ('202020200002','202010200005')
               AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL
              THEN TB.FINAL_ENTY_C_NAME
              WHEN A.STD_PROD_ID IN ('202020200005','202020200006')
               AND TRIM(TB.FINAL_ENTY_C_NAME)  IS NOT NULL
              THEN TB.FINAL_ENTY_C_NAME
              WHEN A.STD_PROD_ID = '201020100057' THEN F.CUST_NAME --ADD BY YJY 20250103 房抵贷（网商引流）取客户名称
              WHEN A.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
               AND TRIM(T1.RECVBL_BANK_CARD_CARD_NO) IS NOT NULL --华兴易贷 --MOD BY LIP 20250310
              THEN TRIM(T1.RECVBL_BANK_CARD_NAME)
              ELSE E.CUST_ACCT_NAME
          END                                                    AS ETR_ACC_NM                 --入账账号户名
        ,CASE WHEN A.STD_PROD_ID IN ('202020200005','202020200006','202020200002','202010200005')
               AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
              WHEN A.STD_PROD_ID IN ('202020200005','202020200006','202020200002','202010200005')
               AND TRIM(TB.FINAL_ENTER_CLEAR_BK_NO) IS NOT NULL
              THEN NVL(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME_A,TCC.SYS_PRTCPTR_BIGAMT_BANK_NAME)
              WHEN A.STD_PROD_ID = '201020100057' THEN '支付宝'  --ADD BY YJY 20250103 暂定房抵贷（网商引流）的入账开户行名称为支付宝
              WHEN A.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
               AND TRIM(T1.RECVBL_BANK_CARD_CARD_NO) IS NOT NULL --华兴易贷 --MOD BY LIP 20250310
              THEN TRIM(T1.RECVBL_BANK_NAME)
              ELSE E.ORG_NAME
          END                                                    AS LOAN_ETR_ACC_OPEN_BANK_NM  --贷款入账账号开户行名称
        ,CASE WHEN A.STD_PROD_ID IN ('202020200005','202020200006')
               AND TRIM(TA.REPAY_ACCT_ID) IS NOT NULL  --网商小贷 取合同栏位的账号
              THEN TA.REPAY_ACCT_ID
              WHEN A.STD_PROD_ID IN ('202020200002','202010200005')
               AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NUM
              WHEN A.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
               AND TRIM(T1.REPAY_BANK_CARD_NUM) IS NOT NULL --华兴易贷 --MOD BY LIP 20250310
              THEN TRIM(T1.REPAY_BANK_CARD_NUM)
              ELSE NVL(TRIM(A.LOAN_REPAY_NUM),TRIM(B.REPAY_NUM))
          END                                                    AS REPY_ACC                   --还款账号
        ,CASE WHEN A.STD_PROD_ID IN ('202020200005','202020200006','202020200002','202010200005')
               AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
              WHEN A.STD_PROD_ID IN ('202020200005','202020200006','202020200002','202010200005')
               AND TRIM(TB.FINAL_ENTER_CLEAR_BK_NO) IS NOT NULL
              THEN NVL(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME_A,TCC.SYS_PRTCPTR_BIGAMT_BANK_NAME)
              WHEN A.STD_PROD_ID = '201020100057' THEN '支付宝' --ADD BY YJY 20250103 暂定房抵贷（网商引流）的还款开户行名称为支付宝
              WHEN A.STD_PROD_ID IN ('201010300040','201010300035','201010300041','201020100060','201020100059')
               AND TRIM(T1.REPAY_BANK_CARD_NUM) IS NOT NULL --华兴易贷 --MOD BY LIP 20250310
              THEN TRIM(T1.REPAY_BANK_NAME)
              ELSE K.ORG_NAME
          END                                                    AS LOAN_REPY_ACC_OPEN_BANK_N  --贷款还款账号开户行名称
        ,CASE WHEN A.ASSET_TRAN_STATUS_CD = '121' THEN 'C0202' --转让
              WHEN A.WRT_OFF_FLG = '1' THEN 'C0201'  --核销 MODIFY BY TANGAN AT 20230103
              WHEN A.LOAN_ACCT_STATUS_CD = 'C' THEN 'C01' --结清 MODIFY BY TANGAN AT 20230103
              WHEN A.LOAN_MODAL_CD = 'ZHC' THEN 'A'  --正常 MODIFY BY TANGAN AT 20230103
              WHEN A.LOAN_MODAL_CD IN ('YUQ','FYJ','FY') THEN 'B' --逾期 MODIFY BY TANGAN AT 20230103
              ELSE TTI.TAR_VALUE_CODE
          END                                                    AS RCPT_STAT                  --借据状态
        ,TTJ.TAR_VALUE_CODE                                      AS ACC_STAT                   --账户状态
        ,CASE WHEN B.STD_PROD_ID IN ('201020100014','201020100012','201020100024'
                                     ,'201020100051','201020100052','201020100054'
                                     ,'201020100062','201020100061') 
              THEN 'Y' --modify by lwb 新增两个饲料e贷 --mod by yjy 20250718 新增饲料e贷-海大集团  201020100062、兴采贷  201020100061 
              WHEN A.CIRCL_LOAN_FLG = '0' THEN 'N'  --新增201020100054好企贷-IPC产品为循环贷
              WHEN A.CIRCL_LOAN_FLG = '1'THEN 'Y'
              ELSE A.CIRCL_LOAN_FLG
          END                                                    AS REV_LOAN_FLG               --循环贷贷款标志  mod by hulj 20230816
        ,NULL                                                    AS REL_PSN_GUA_LOAN_FLG       --关系人保证贷款标志
        ,A.NEXT_REPAY_INT_AMT                                    AS BEAR_OR_RED_AMT            --承担或减免的信贷费用金额
        ,'Y'                                                     AS BIO_LOAN_FLG               --客户境内外标志
        ,'800924'                                                AS DEPT_LINE                  --部门条线/*零售信贷部(普惠金融部)*/
        ,'零售贷款'                                              AS DATA_SRC                   --数据来源
        ,TA.LMT_CONT_ID                                          AS LMT_CONT_ID                --额度合同编号
        ,A.REPAY_WAY_CD                                          AS GXH_PAY_TYPE               --还款方式
        ,A.REPAY_PED_CORP_CD                                     AS GXH_PAY_FREQ               --还款频率
        ,TO_CHAR(A.ASSET_TRAN_DT,'YYYYMMDD')                     AS ASSET_TRAN_DT              --资产转让日期
        ,'Y'                                                     AS LOAN_DIR_BIO_FLG           --贷款投向境内外标识 --零售贷款默认为境内
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_INT_AMT,0)
          END                                                    AS OVD_INT_BAL                --逾期利息金额
        ,B.CUST_CRDT_TOT                                         AS LOAN_CRDT_LMT_TOT          --放款时单户授信总额度
        ,CASE WHEN B.REFAC_LOAN_STATUS_CD = '1' THEN 'Y'
              ELSE 'N'
          END                                                    AS REFAC_FLG                  --支小再贷款标识
        ,NULL                                                    AS BILL_ACT_AMT               --转帖现、福费廷的贷款金额取实付金额
        ,NULL                                                    AS LOAN_MODAL_CD              --贷款形态代码
        ,NULL                                                    AS OPER_ORG_ID                --经办机构编号 MOD BY HULJ 20221122
        ,NULL                                                    AS OPER_TELLER_ID             --经办柜员编号 MOD BY HULJ 20221122
        ,H1.LOAN_ACT_DSTR_DT                                     AS LOAN_ACT_FIRST_DT          --本行首贷日期 MOD BY HULJ 20221122
        ,TO_CHAR(A.RENEW_EXP_DT,'YYYYMMDD')                      AS RENEW_EXP_DAY              --展期到期日期 MOD BY HULJ 20221122
        ,TRIM(B.CUST_MGR_ID)                                     AS LOAN_MGR_ID                --借据主办客户经理号 --ADD BY LIP 20251218
        ,TRIM(B.RGST_TELLER_ID)                                  AS LOAN_TELLER_ID             --借据主办柜员号 --ADD BY LIP 20251218
        ,TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')                    AS CNCL_DT                    --核销日期     ADD BY MW 20221123
        ,A.INT_RAT_ADJ_WAY_CD                                    AS FIXED_INT_MARK             --利率是否固定
        ,A.IN_BS_INT                                             AS IN_BS_INT                  --表内利息
        ,A.OFF_BS_INT                                            AS OFF_BS_INT                 --表外利息
        ,A.DISTR_AMT                                             AS DISTR_AMT                  --放款金额
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                          AS DISTR_DT                   --放款日期
        ,CASE --ADD BY YJY 20250103 新增对房抵贷产品的日期判断
             WHEN A.STD_PROD_ID = '201020100057'
              AND (A.CLOS_ACCT_DT >= V_MONTH_START_DATE - 1 OR A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
              AND (NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE - 1 OR D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD'))
              AND (NVL(A.ASSET_TRAN_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE - 1 OR A.ASSET_TRAN_DT = TO_DATE('00010101','YYYYMMDD'))
             THEN 'Y'
             WHEN (A.CLOS_ACCT_DT >= V_MONTH_START_DATE OR A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
              AND (NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE OR D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD'))
              AND (NVL(A.ASSET_TRAN_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE OR A.ASSET_TRAN_DT = TO_DATE('00010101','YYYYMMDD'))
             THEN 'Y'
             ELSE 'N'
         END                                                     AS EAST_FLG                   --EAST_口径标识
        ,NULL                                                    AS CTR_NT_ID                  --成交单编号
        ,A.RECVBL_PNLT                                           AS RECVBL_PNLT                --应收罚息
        ,A.RECVBL_PNLT                                           AS COLL_PNLT                  --催收罚息
        ,A.RECVBL_COMP_INT                                       AS RECVBL_COMP_INT            --应收复息
        ,A.RECVBL_INT_SUB                                        AS RECVBL_INT_SUB             --应收贴息
        ,A.RECVBL_FINE                                           AS RECVBL_FINE                --应收罚息
        ,A.RECVBL_OVER_INT                                       AS RECVBL_OVER_INT            --应收欠息
        ,A.COLL_OVER_INT                                         AS COLL_OVER_INT              --催收欠息
        ,M.LOAN_USAGE_SUBCLASS_CD                                AS LOAN_USEAGE_SUB_CL         --贷款用途细类
        ,CASE WHEN B.CUST_CHAR_CD = '01' THEN '个体工商户'
              WHEN B.CUST_CHAR_CD = '02' THEN '小微企业主'
              WHEN B.CUST_CHAR_CD = '03' THEN '其他'
              WHEN B.CUST_CHAR_CD = '04' THEN '大中型企业主'
              WHEN B.CUST_CHAR_CD = '05' THEN '其他非企业负责人'
              WHEN B.CUST_CHAR_CD = '06' THEN '其他无营业执照负责人'
          END                                                    AS CUST_CHAR                   --客户性质
        ,NULL                                                    AS OUT_ACCT_FLOW_NUM           --出账流水号
        ,B.CUST_ID                                               AS ICMS_CUST_ID                --信贷客户编号
        ,B.BASE_RAT                                              AS BASE_RAT_IMAS               --基准利率IMAS --ADD BY LIP 20230810
        ,A.ABS_FLG                                               AS ABS_FLG                     --资产证券化标志
        ,A.ASSET_TRAN_FLG                                        AS ASSET_TRAN_FLG              --资产转让标志
        ,B.REGROUP_LOAN_FLG                                      AS REGROUP_LOAN_FLG            --重组贷款标志
        ,B.REGROUP_LOAN_TYPE_CD                                  AS REGROUP_LOAN_TYPE_CD        --重组贷款类型代码
        ,B.PROVI_FOR_AGED_PROPERTY_FLG                           AS PROVI_FOR_AGED_PROPERTY_FLG --养老产业标志 --ADD BY YJY 20240507
        ,TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')                         AS PAYOFF_DT                   --结清日期     --ADD BY YJY 20241022
        ,NVL(B.SUIT_FEE_BAL,0)                                   AS SUIT_FEE_BAL                --诉讼费余额   --MOD BY YJY 20250324
        ,M.ACCT_FLG                                              AS ISWHITE_FLG                 --白户标志     --ADD BY LAL 20250904
        ,NULL                                                    AS GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
        ,CASE
             WHEN A.STD_PROD_ID = '201020100057'
              AND (A.CLOS_ACCT_DT >= V_YEAR_START_DATE - 1 OR A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
              AND (NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE - 1 OR D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD'))
              AND (NVL(A.ASSET_TRAN_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE - 1 OR A.ASSET_TRAN_DT = TO_DATE('00010101','YYYYMMDD'))
             THEN 'Y'
             WHEN (A.CLOS_ACCT_DT >= V_YEAR_START_DATE OR A.CLOS_ACCT_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
              AND (NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE OR D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD'))
              AND (NVL(A.ASSET_TRAN_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE OR A.ASSET_TRAN_DT = TO_DATE('00010101','YYYYMMDD'))
             THEN 'Y'
             ELSE 'N'
         END                                                      AS YBT_FLG                     --一表通口径标识--ADD BY PSF 20250916
       ,CATE.ACCT_MODIF_CATE_CD                                   AS ACCT_MODIF_CATE_CD          --账户变更类别代码 --ADD BY LYH 20260127
       ,NULL                                                      AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
       ,NULL                                                      AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
       ,NULL                                                      AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
   FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
  INNER JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据信息
     ON B.DUBIL_ID = A.DUBIL_NUM
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO TA --零售贷款合同信息表
     ON TA.CONT_ID = A.CONT_ID
    AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H TB --贷款合同个人贷款附属信息历史 --MODIFY BY TANGAN AT 20230107 取助贷的入账和出账账号
     ON TB.CONT_ID = A.CONT_ID
    AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO T1 --零售贷款业务合同补充信息 --ADD BY LIP 20250310
     ON T1.CONT_ID = A.CONT_ID
    AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   --MOD BY LIP 20230530 取互联网合作产品的账户所属行
   LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM TC
     ON TC.SYS_PRTCPTR_BIGAMT_BANK_NO = TB.FINAL_ENTER_CLEAR_BK_NO
    AND TC.RANK = 1
    AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN CORP_CUST TCC
     ON TCC.SYS_PRTCPTR_BIGAMT_BANK_NO = TB.FINAL_ENTER_CLEAR_BK_NO
    AND TCC.RN = 1
   LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO M --零售贷款申请信息
     ON M.LOAN_APPL_FLOW_NUM = TA.APV_FLOW_NUM
    AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C --标准产品信息
     ON C.PROD_ID = A.STD_PROD_ID
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO D --贷款核销信息
     ON D.DUBIL_ID = A.DUBIL_NUM
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO F --个人客户基本信息
     ON F.CUST_ID = A.CUST_ID
    AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RETL_LOAN_REPAY_PLAN_1 DD --还款计划 取连续/累计欠款期数
     ON DD.DUBIL_ID = B.DUBIL_ID
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 E --表内借据信息表临时表02 --MODIFY BY TANGAN TA 20221124 取入账账号户名和贷款入账账号开户行名称
     ON E.CUST_ACCT_ID = A.LOAN_DISTR_ACCT_NUM
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP02 K --表内借据信息表临时表02
     ON K.CUST_ACCT_ID = NVL(TRIM(A.LOAN_REPAY_NUM),TRIM(B.REPAY_NUM))
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP04 AC --精准扶贫按客户整合
     ON AC.CUST_ID = A.CUST_ID
    AND AC.ACCT_DURAN = '2021-04'
   LEFT JOIN RRP_MDL.ADD_POVERTY_RELIF AD --精准扶贫名录20211231填报数据基表
     ON AD.LOAN_NUM = A.DUBIL_NUM
   LEFT JOIN O_IML_REF_PUB_CD PUB --公共代码表 取贷款用途
     ON PUB.CD_ID = 'CD1274'
    AND PUB.CD_VAL = TA.BORW_USAGE_TYPE_CD
   LEFT JOIN RRP_MDL.CODE_MAP TTA --码值映射表(贷款类型)
     ON TTA.SRC_VALUE_CODE = B.STD_PROD_ID
    AND TTA.SRC_CLASS_CODE = 'STD0002'
    AND TTA.TAR_CLASS_CODE = 'T0001'
    AND TTA.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTB --码值映射表(贷款用途)
     ON TTB.SRC_VALUE_CODE = TA.BORW_USAGE_TYPE_CD
    AND TTB.SRC_CLASS_CODE = 'CD1274'
    AND TTB.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTC --码值映射表(五级分类)
     ON TTC.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
    AND TTC.SRC_CLASS_CODE = 'CD1032'
    AND TTC.TAR_CLASS_CODE = 'D0005'
    AND TTC.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTE --码值映射表(还款方式)
     ON TTE.SRC_VALUE_CODE = A.INT_SET_WAY_CD
    AND TTE.SRC_CLASS_CODE = 'CD2778'
    AND TTE.TAR_CLASS_CODE = 'D0103'
    AND TTE.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTF --码值映射表(贷款形式)
     ON TTF.SRC_VALUE_CODE = B.LOAN_HAPP_TYPE_CD
    AND TTF.SRC_CLASS_CODE = 'CD1364'
    AND TTF.TAR_CLASS_CODE = 'D0008'
    AND TTF.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTG --码值映射表(放款方式)
     ON TTG.SRC_VALUE_CODE = B.MODE_PAY_CD
    AND TTG.SRC_CLASS_CODE = 'CD1372'
    AND TTG.TAR_CLASS_CODE = 'D0104'
    AND TTG.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTH --码值映射表(计息方式)
     ON TTH.SRC_VALUE_CODE = A.INT_SET_WAY_CD
    AND TTH.SRC_CLASS_CODE = 'CD2778'  --modify by tangan at 20230103 调整码值映射
    AND TTH.TAR_CLASS_CODE = 'D0061'
    AND TTH.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTI --码值映射表(借据状态)
     ON TTI.SRC_VALUE_CODE = B.DUBIL_STATUS_CD
    AND TTI.SRC_CLASS_CODE = 'CD2554'
    AND TTI.TAR_CLASS_CODE = 'D0007'
    AND TTI.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTJ --码值映射表（账户状态）
     ON TTJ.SRC_VALUE_CODE = A.LOAN_ACCT_STATUS_CD
    AND TTJ.SRC_CLASS_CODE = 'CD2554'
    AND TTJ.TAR_CLASS_CODE = 'Z0018'
    AND TTJ.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TI  --利率种类转码
     ON TI.SRC_VALUE_CODE = A.INT_RAT_BASE_TYPE_CD
    AND TI.SRC_CLASS_CODE = 'CD1010'
    AND TI.TAR_CLASS_CODE = 'Z0015'
    AND TI.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTK --利率类型转码
     ON TTK.SRC_VALUE_CODE = A.INT_RAT_FLOAT_WAY_CD
    AND TTK.SRC_CLASS_CODE = 'CD1016'
    AND TTK.TAR_CLASS_CODE = 'Z0007'
    AND TTK.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TJ  --码值映射表(渠道转码)
     ON TJ.SRC_VALUE_CODE = M.CHN_ID
    AND TJ.SRC_CLASS_CODE = 'CD2366'
    AND TJ.TAR_CLASS_CODE = 'Z0014'
    AND TJ.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTL --利率调整频率
     ON TTL.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CORP_CD
    AND TTL.SRC_CLASS_CODE = 'CD1041'
    AND TTL.TAR_CLASS_CODE = 'D0105'
    AND TTL.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTM --担保方式转码
     ON TTM.SRC_VALUE_CODE = B.GUAR_WAY_CD
    AND TTM.SRC_CLASS_CODE = 'CD2656'
    AND TTM.TAR_CLASS_CODE = 'D0002'
    AND TTM.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CONFIG_LOAN_PROD CONFIG1
     ON CONFIG1.STD_PROD_ID = A.STD_PROD_ID
   LEFT JOIN M_LOAN_IN_DUBILL_INFO_TEMP00 H1  --取首贷标志
     ON H1.RCPT_ID = A.DUBIL_NUM  --ADD BY 20220824 XUXIAOBIN  取是否首贷标志
   LEFT JOIN (SELECT STD_PROD_ID   AS STD_PROD_ID  --标准产品编号
                    ,MIN(HZFS)     AS HZFS      --合作方式
                FROM RRP_MDL.M_DICT_G09_HZF --G09互联网贷款产品信息静态表
                GROUP BY STD_PROD_ID ) HZF   --ADD BY WEIYONGZHAO 20230523 关联取网贷产品和类别
     ON HZF.STD_PROD_ID = A.STD_PROD_ID
   LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO ORG_DQ
     ON ORG_DQ.ORG_ID = A.ACCT_INSTIT_ID
    AND TRIM(ORG_DQ.COUNTY_CD) IS NOT NULL
    AND ORG_DQ.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   --ADD BY YJY 20250718 判断互联网业务
   LEFT JOIN (SELECT A.OBJECTNO AS DUBIL_ID  --业务流水号
                FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
               INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                  ON B.TAGID = A.TAGID --标签编号
                 AND B.ITEMNO = A.TAGVALUE --标签值
                 AND B.ITEMNAME = '是'
                 AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
               WHERE A.TAGHIREARCHY = '60' --标签层级
                 AND A.TAGID = '2025080800000001' --标签编号：互联网业务
                 AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) HD
       ON HD.DUBIL_ID = A.DUBIL_NUM
  --ADD BY LYH 20260127
  LEFT JOIN CL_AMEND CATE
    ON CATE.MODIF_CONTENT_KEY_VAL = A.ACCT_ID
   AND CATE.RN = 1
  WHERE A.DUBIL_NUM IS NOT NULL
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ACC_ID                      --账户编号
    ,RCPT_ID                     --借据编号
    ,THIRD_RCPT_ID               --内部借据号 ADD BY YJY 20250521
    ,CONT_ID                     --合同编号
    ,BILL_NO                     --票据号码
    ,COOP_AGRT_ID                --合作协议编号
    ,CUST_ID                     --客户编号
    ,ORG_ID                      --机构编号
    ,SUBJ_ID                     --科目编号
    ,LOAN_STD_PROD_ID            --贷款标准产品编号
    ,LOAN_STD_PROD_NM            --贷款标准产品名称
    ,LOAN_PROD_ID                --贷款产品编号
    ,LOAN_PROD_NM                --贷款产品名称
    ,LOAN_BIZ_TYP                --贷款业务类型
    ,CUR                         --币种
    ,LOAN_AMT                    --借款金额
    ,LOAN_BAL                    --贷款余额
    ,INT_ADJ                     --利息调整
    ,FAIR_VAL_CHG                --公允价值变动
    ,OVD_PRIN_BAL                --逾期本金余额
    ,IN_INT_OVD_BAL              --表内欠息余额
    ,OUT_INT_OVD_BAL             --表外欠息余额
    ,LOAN_ACT_DSTR_DT            --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT            --贷款原始到期日期
    ,LOAN_ACT_EXP_DT             --贷款实际到期日期
    ,ACT_END_DT                  --实际终止日期
    ,LAST_REPY_DT                --上次还款日期
    ,LAST_REPY_AMT               --上次还款金额
    ,VAL_DT                      --起息日期
    ,OPEN_ACC_DT                 --开户日期
    ,CNL_ACC_DT                  --销户日期
    ,PRIN_OVD_DT                 --本金逾期日期
    ,INT_OVD_DT                  --利息逾期日期
    ,OVD_DAYS                    --逾期天数
    ,OVD_TYP                     --逾期类型
    ,LOAN_USEAGE                 --贷款用途
    ,LVL5_CL                     --五级分类
    ,GUA_MODE                    --担保方式
    ,LOAN_DIR_RGN                --贷款投向地区
    ,LOAN_DIR_IDY                --贷款投向行业
    ,SYN_LOAN_FLG                --银团贷款标志
    ,PROJ_LOAN_FLG               --项目贷款标志
    ,IDY_STRU_ADJ_TYP            --产业结构调整类型
    ,IDY_TRNST_UPG_FLG           --工业转型升级标志
    ,STRTG_EMER_IDY_TYP          --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
    ,AGR_REL_LOAN_FLG            --涉农贷款标志
    ,RL_EST_LOAN_FLG             --房地产贷款标志
    ,IALL_LOAN_FLG               --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP            --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN               --贷款办理渠道
    ,NET_LOAN_FLG                --互联网贷款标志
    ,NET_LOAN_PROD_TYP           --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
    ,REPY_MODE                   --还款方式
    ,LOAN_FRM                    --贷款形式
    ,RCMM_LOAN_FLG               --重组贷款标识
    ,ADJ_BAD_FLG                 --下调为不良标志
    ,ALDY_RCMM_FLG               --曾重组标志
    ,CTON_PRD_LOAN_FLG           --缩期贷款标志
    ,CASH_TRF_FLG                --现转标志
    ,FST_LOAN_FLG                --首贷户贷款标志
    ,FIRST_LOAN_FLG              --首次贷款标志
    ,PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE          --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
    ,RATE_RE_PRC_DT              --利率重新定价日期
    ,RATE_FLT_FREQ               --利率浮动频率
    ,RATE_TYP                    --利率类型
    ,AST_SCRTZ_PROD_ID           --资产证券化产品编号
    ,EXEC_RATE                   --执行利率
    ,BASE_RATE                   --基准利率
    ,CNTR_GUA_LOAN_FLG           --反担保贷款标志
    ,RATE_FLT_VAL                --利率浮动值
    ,PRC_BASE_TYP                --定价基准类型
    ,TOT_PRD_NUM                 --总期数
    ,CURR_PRD                    --当前期数
    ,CUM_DEBT_PRD_NUM            --累计欠款期数
    ,CNU_DEBT_PRD_NUM            --连续欠款期数
    ,EXTN_CNT                    --展期次数
    ,DSBR_MODE                   --放款方式
    ,INT_CALC_MODE               --计息方式
    ,MRGN_PCT                    --保证金比例
    ,MRGN_CUR                    --保证金币种
    ,MRGN                        --保证金
    ,MRGN_ACC                    --保证金账号
    ,LOAN_OFR_NO                 --信贷员工号
    ,ACCRD_INT                   --应计利息
    ,PRO_IMPT                    --减值准备
    ,COM_PRO                     --一般准备
    ,SPCL_PRO                    --专项准备
    ,ESP_PRO                     --特别准备
    ,SPCL_LOAN_FLG               --专项贷款标志
    ,ORIG_RCPT_NO                --原借据号
    ,FND_PCT                     --出资比例
    ,ETR_ACC                     --入账账号
    ,ETR_ACC_NM                  --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
    ,REPY_ACC                    --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
    ,RCPT_STAT                   --借据状态
    ,ACC_STAT                    --账户状态
    ,REV_LOAN_FLG                --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
    ,BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                --境内外标志
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,LMT_CONT_ID                 --额度合同编号
    ,GXH_PAY_TYPE                --还款方式
    ,GXH_PAY_FREQ                --还款频度
    ,LOAN_DIR_BIO_FLG            --贷款投向境内外标识
    ,OVD_INT_BAL                 --逾期利息金额
    ,REFAC_FLG                   --支小再贷款标识
    ,BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD               --贷款形态代码
    ,OPER_ORG_ID                 --经办机构编号 MOD BY HULJ 20221122
    ,OPER_TELLER_ID              --经办柜员编号 MOD BY HULJ 20221122
    ,LOAN_ACT_FIRST_DT           --本行首贷日期 MOD BY HULJ 20221122
    ,RENEW_EXP_DAY               --展期到期日期 MOD BY HULJ 20221122
    ,CNCL_DT                     --核销日期     ADD BY MW 20221123
    ,FIXED_INT_MARK              --利率是否固定
    ,IN_BS_INT                   --表内利息
    ,OFF_BS_INT                  --表外利息
    ,HOLD_DAYS                   --持票天数
    ,DISTR_AMT                   --放款金额
    ,DISTR_DT                    --放款日期
    ,EAST_FLG                    --EAST口径标识
    ,CTR_NT_ID                   --成交单编号
    ,RECVBL_PNLT                 --应收罚息
    ,COLL_PNLT                   --催收罚息
    ,RECVBL_COMP_INT             --应收复息
    ,RECVBL_INT_SUB              --应收贴息
    ,RECVBL_FINE                 --应收罚息
    ,RECVBL_OVER_INT             --应收欠息
    ,COLL_OVER_INT               --催收欠息
    ,LOAN_USEAGE_SUB_CL          --贷款用途细类
    ,CUST_CHAR                   --客户性质
    ,OUT_ACCT_FLOW_NUM           --出账流水号
    ,INDTYPE                     --联合网贷客户性质
    ,ICMS_CUST_ID                --信贷客户编号
    ,INTNAL_CARR_FLG             --内部结转标志
    ,BASE_RAT_IMAS               --基准利率IMAS ADD BY LIP 20230810
    ,CRED_RHT_TURN_FLG           --债权直转标志 ADD BY HULJ20230914
    ,LOAN_TYPE_CD                --借据类型代码 ADD BY HULJ20230914
    ,INIT_DISTR_AMT              --原始放款金额 ADD BY LIP 20230925
    ,INIT_DISTR_DT               --原始放款日期 ADD BY LIP 20230925
    ,INIT_TOT_PERDS              --原始总期数   ADD BY LIP 20230925
    ,INIT_CURR_PRD               --原始当前期数 ADD BY LIP 20230925
    ,REGROUP_LOAN_FLG            --重组贷款标志
    ,REGROUP_LOAN_TYPE_CD        --重组贷款类型代码 ADD BY LIP 20240704
    ,HAPP_WAY_CD                 --发生方式代码     ADD BY YJY 20241010
    ,PAYOFF_DT                   --结清日期         ADD BY YJY 20241022
    ,SUIT_FEE_BAL                --诉讼费余额       ADD BY YJY 20241217
    ,ISWHITE_FLG                 --白户标志         ADD BY LAL 20250904
    ,GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
    ,YBT_FLG                     --一表通口径标识 --ADD BY PSF 20250916
    ,SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
    )
  /*--MOD BY LIP 20230927 
  --MOD BY YJY 20251104 调整为创建联合网贷还款计划临时表
  WITH UNITE_WL_REPAY_PLAN AS (
    SELECT N.DUBIL_ID,N.INIT_TOT_PERDS TOT_PERDS,N.INIT_REPAY_PERDS REPAY_PERDS,
           N.REPAYBL_DT,MAX(N.INIT_VALUE_DT) AS VALUE_DT,N.ETL_DT,N.PROD_ID,
           --SUM(CASE WHEN N.OVDUE_FLG = '1' AND N.REPAY_PERDS <> 0 THEN 1 ELSE 0 END ) OVDUE_FLG,--逾期标志为是 0为否
           --MOD BY 20240105 当产品是微粒贷，且逾期标志为否，但是超过了到期日期，EAST算逾期
           SUM(CASE WHEN (N.OVDUE_FLG = '1' OR (N.PROD_ID IN ('202010100006','202010100008','202020100003')
                     AND N.OVDUE_FLG = '0' AND N.REPAY_FLG = '0'
                     AND N.REPAYBL_DT IS NOT NULL AND N.REPAYBL_DT <> TO_DATE('00010101','YYYYMMDD')
                     AND N.REPAYBL_DT < TO_DATE(V_P_DATE,'YYYYMMDD') - 1))
                     AND N.REPAY_PERDS <> 0 THEN 1 ELSE 0 END) AS OVDUE_FLG,--逾期标志为是 0为否
           MIN(CASE WHEN N.REPAY_FLG = '0' AND N.REPAY_PERDS <> 0 THEN 0 ELSE 1 END) AS REPAY_FLG --未偿还
      FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_PLAN N --联合网贷还款计划
     WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY N.DUBIL_ID,N.INIT_TOT_PERDS,N.INIT_REPAY_PERDS,N.REPAYBL_DT,N.ETL_DT,N.PROD_ID),
  UNITE_WL_REPAY_PLAN_1 AS(
    SELECT N.DUBIL_ID,
           MAX(N.TOT_PERDS) AS TOT_PERDS,
           MAX(N.REPAY_PERDS) AS REPAY_PERDS,
           --MOD BY LIP 20230614 修改当前期数的取数口径
           MAX(CASE WHEN N.VALUE_DT >= TO_DATE(V_P_DATE,'YYYYMMDD') THEN 0 ELSE N.REPAY_PERDS END) AS CURR_PERDS,
           --MOD BY LIP 20240104 微粒贷的当前期数按照采集日期的下一期来取数
           MIN(CASE WHEN N.PROD_ID IN ('202010100006','202010100008','202020100003')
                     AND REPAYBL_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
                    THEN N.REPAY_PERDS ELSE N.TOT_PERDS END) AS WLD_CURR_PERDS,
           SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                     AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
                     AND N.REPAY_FLG = 0 --未偿还
                    THEN 1 ELSE 0 END) AS LXQKQS, --连续欠款期数
           SUM(CASE WHEN N.OVDUE_FLG >= 1 --逾期标志为是
                     AND N.REPAYBL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1 --未偿还
                    THEN 1 ELSE 0 END) AS LJQKQS --累计欠款期数
      FROM UNITE_WL_REPAY_PLAN N --联合网贷还款计划
     WHERE N.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY N.DUBIL_ID)  */
  SELECT V_P_DATE                                        AS DATA_DT                             --数据日期
        ,A.LP_ID                                         AS LGL_REP_ID                          --法人编号
        ,A.DUBIL_ID                                      AS ACC_ID                              --账户编号
        --MOD BY 20250725 回退核算改造前版本
        ,A.DUBIL_ID                                      AS RCPT_ID                             --借据编号
        --,A.CORE_DUBIL_ID                                 AS RCPT_ID                             --借据编号  MOD BY YJY 20250521 取联合网贷的核心借据号
        --,A.DUBIL_ID                                      AS THIRD_RCPT_ID                       --第三方借据编号  ADD BY YJY 20250521
        ,A.CORE_DUBIL_ID                                 AS THIRD_RCPT_ID                       --内部借据号 --MOD BY LIP 20250725 IMAS发放日期20250703-20250723的借据使用
        ,A.DUBIL_ID                                      AS CONT_ID                             --合同编号
        ,A.DUBIL_ID                                      AS BILL_NO                             --票据号码
        ,T8.EXT_CUST_ID                                  AS COOP_AGRT_ID                        --合作协议编号 MD BY MW 从贷款合同表取，此处不存值
        ,A.CUST_ID                                       AS CUST_ID                             --客户编号
        ,A.ACCT_INSTIT_ID                                AS ORG_ID                              --机构编号
        ,A.SUBJ_ID                                       AS SUBJ_ID                             --科目编号
        ,A.STD_PROD_ID                                   AS LOAN_STD_PROD_ID                    --贷款标准产品编号
        ,M.PROD_NAME                                     AS LOAN_STD_PROD_NM                    --贷款标准产品名称
        ,A.STD_PROD_ID                                   AS LOAN_PROD_ID                        --贷款产品编号
        --MOD BY LIP 20230915 将网商贷债权直转的标记出来以便区分
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
               AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN '网商贷（债权直转）'
              ELSE M.PROD_NAME
          END                                            AS LOAN_PROD_NM                        --贷款产品名称
        ,NVL(TTA.TAR_VALUE_CODE,A.STD_PROD_ID)           AS LOAN_BIZ_TYP                        --贷款业务类型
        ,A.CURR_CD                                       AS CUR                                 --币种
        ,A.DUBIL_AMT                                     AS LOAN_AMT                            --借款金额
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE A.CURRT_BAL
          END                                            AS LOAN_BAL                            --贷款余额
        ,0                                               AS INT_ADJ                             --利息调整
        ,0                                               AS FAIR_VAL_CHG                        --公允价值变动
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0)
          END                                            AS OVD_PRIN_BAL                        --逾期本金余额
        /*,A.IN_BS_OVER_INT_BAL                            IN_INT_OVD_BAL                      --表内欠息余额*/
        ,A.IN_BS_INT                                     AS IN_INT_OVD_BAL                      --表内欠息余额 --MOD BY YJY IN 20240702
        /*,A.OFF_BS_OVER_INT_BAL                           OUT_INT_OVD_BAL                     --表外欠息余额*/
        ,A.OFF_BS_INT                                    AS OUT_INT_OVD_BAL                     --表外欠息余额 --MOD BY YJY IN 20240702
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                  AS LOAN_ACT_DSTR_DT                    --贷款实际发放日期
        --MOD BY LIP 20240704 网商贷3.0调整原始到期日期取数
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
              THEN TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD')
              ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
          END                                            AS LOAN_ORIG_EXP_DT                    --贷款原始到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                    AS LOAN_ACT_EXP_DT                     --贷款实际到期日期
        ,CASE WHEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101')
               AND TFF.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TO_CHAR(TFF.FIR_WRT_OFF_DT,'YYYYMMDD') --核销日期
              WHEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               AND A.STD_PROD_ID NOT IN ('202010100004') --京东
              THEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')
              --MOD BY LIP 20230707 加上判断上次还款日期要大于放款日期的数据
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) = 0
               AND A.LAST_REPAY_DT >= A.DISTR_DT
               AND TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               AND A.STD_PROD_ID = '202010100004' --京东
              THEN TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')
              WHEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
              THEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')
              ELSE '29991231'
          END                                            AS ACT_END_DT                          --实际终止日期
        ,TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')             AS LAST_REPY_DT                        --上次还款日期
        ,NULL                                            AS LAST_REPY_AMT                       --上次还款金额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                  AS VAL_DT                              --起息日期   --MODIFY BY MW  20221228 调换开户日期和起息日期
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')              AS OPEN_ACC_DT                         --开户日期   --MODIFY BY MW                                         CNL_ACC_DT                */           --销户日期 --modify by hulj
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')                 AS CNL_ACC_DT                          --销户日期
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.PRIC_OVDUE_DAYS,'YYYYMMDD')
          END                                            AS PRIN_OVD_DT                         --本金逾期日期
        ,CASE WHEN A.INT_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.INT_OVDUE_DAYS,'YYYYMMDD')
          END                                            AS INT_OVD_DT                          --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)    AS OVD_DAYS                            --逾期天数
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
              WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
              WHEN A.PRIC_OVDUE_DAYS = 0 AND A.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
              ELSE NULL
          END                                            AS OVD_TYP                             --逾期类型
        ,PUB.CD_DESCB                                    AS LOAN_USEAGE                         --贷款用途 --MODIFY BY MW 20221222直取数仓代码表
        ,TTC.TAR_VALUE_CODE                              AS LVL5_CL                             --五级分类
        ,TTM.TAR_VALUE_CODE                              AS GUA_MODE                            --担保方式
         --MOD BY LIP 20230531
        ,COALESCE(CASE WHEN TRIM(C.RG_COUNTY_CD) NOT IN ('1000','999999','000000')
                       THEN CASE WHEN SUBSTR(SUBSTR(TRIM(C.RG_COUNTY_CD),1,6),-4)= '0000'
                                 THEN SUBSTR(C.RG_COUNTY_CD,1,2)||'0101'
                                 WHEN SUBSTR(SUBSTR(TRIM(C.RG_COUNTY_CD),1,6),-2)= '00'
                                  AND SUBSTR(TRIM(C.RG_COUNTY_CD),1,6) NOT IN ('441900','442000','460300','460400')
                                 THEN SUBSTR(C.RG_COUNTY_CD,1,4)||'01'
                                 ELSE SUBSTR(TRIM(C.RG_COUNTY_CD),1,6)
                             END
                   END,
                   CASE WHEN E.CERT_TYPE_CD IN ('1010','1011')
                        THEN CASE WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-4)= '0000'
                                  THEN SUBSTR(E.CERT_NO,1,2)||'0101'
                                  WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-2)= '00'
                                   AND SUBSTR(E.CERT_NO,1,6) NOT IN ('441900','442000','460300','460400')
                                  THEN SUBSTR(E.CERT_NO,1,4) || '01'
                                  ELSE SUBSTR(E.CERT_NO,1,6)
                             END
                   END,
                   CASE WHEN A.BUS_BREED_ID = '0900600100001' AND LENGTH(TRIM(E.CERT_NO))=18 --微粒贷
                        THEN CASE WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-4)= '0000'
                                  THEN SUBSTR(E.CERT_NO,1,2)||'0101'
                                  WHEN SUBSTR(SUBSTR(E.CERT_NO,1,6),-2)= '00'
                                   AND SUBSTR(E.CERT_NO,1,6) NOT IN ('441900','442000','460300','460400')
                                  THEN SUBSTR(E.CERT_NO,1,4) || '01'
                                  ELSE SUBSTR(E.CERT_NO,1,6)
                             END
                   END,
                   CASE WHEN TRIM(E.RG_CD) IN ('1000','999999','000000')
                        THEN NULL
                        ELSE TRIM(E.RG_CD)
                    END)                                 AS LOAN_DIR_RGN                --贷款投向地区
        ,CASE WHEN A.DIR_INDUS_CD = '-' THEN 'Z'
              ELSE NVL(A.DIR_INDUS_CD,'Z')
          END                                            AS LOAN_DIR_IDY                        --贷款投向行业
        ,'N'                                             AS BANK_TAX_COOP_LOAN_FLG              --银团贷款标志
        ,'N'                                             AS PROJ_LOAN_FLG                       --项目贷款标志  --经业务确认 经营性物业贷款划分为一版固定资产贷款
        ,NULL                                            AS IDY_STRU_ADJ_TYP                    --产业结构调整类型
        ,NULL                                            AS IDY_TRNST_UPG_FLG                   --工业转型升级标志
        ,NULL                                            AS STRTG_EMER_IDY_TYP                  --战略新兴产业类型
        ,'N'                                             AS BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
        ,CASE WHEN (E.FARM_FLG = '1') THEN 'Y'
              ELSE 'N'
          END                                            AS AGR_REL_LOAN_FLG                    --涉农贷款标志
        ,NULL                                            AS RL_EST_LOAN_FLG                     --房地产贷款标志
        ,NULL                                            AS IALL_LOAN_FLG                       --投贷联动贷款标志
        ,NULL                                            AS OV_SEA_MRG_LOAN_FLG                 --境外并购贷款标志
        ,NULL                                            AS GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
        ,NULL                                            AS ENT_GUA_LOAN_TYP                    --创业担保贷款类型
        ,NULL                                            AS CAMPUS_CNSMP_LOAN_FLG               --校园消费贷款标志
        ,NULL                                            AS LCL_GOVFINPLTF_LOAN_FLG             --地方政府融资平台贷款标志
        ,NULL                                            AS LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                            AS FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                            AS POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
        ,'03'                                            AS LOAN_HDL_CHAN                       --贷款办理渠道 --MOD BY 20250227 第三方互联网平台
        ,'Y'                                             AS NET_LOAN_FLG                        --互联网贷款标志
        ,CASE --MOD BY YJY 20251104 优先判断201020100063微业贷3.0（好企贷-数据贷）的业务类型
              WHEN A.STD_PROD_ID = '201020100063' AND A.INTNAL_LOAN_TYPE_CD = '01' THEN '3' --自营
              WHEN A.STD_PROD_ID = '201020100063' AND A.INTNAL_LOAN_TYPE_CD = '02' THEN '2' --助贷  
              WHEN A.STD_PROD_ID = '201020100063' AND A.INTNAL_LOAN_TYPE_CD = '03' THEN '1' --联合贷  
              WHEN HZF.HZFS = '01' THEN '1'  --联合贷
              WHEN HZF.HZFS = '02' THEN '2'  --助贷
              WHEN HZF.HZFS = '03' THEN '3'  --自营
          END                                            AS NET_LOAN_PROD_TYP                   --网贷产品类别
        ,NULL                                            AS CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
        ,TTD.TAR_VALUE_CODE                              AS THREPY_MODE                         --还款方式
        --MOD BY LIP 20240704 网商贷3.0
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND A.REGROUP_FLG = '1' THEN '04' --重组贷款
              ELSE '01'
          END                                            AS LOAN_FRM                            --贷款形式
        --MOD BY LIP 20240704 网商贷3.0
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND A.REGROUP_FLG = '1' THEN 'Y'
              ELSE 'N'
          END                                            AS RCMM_LOAN_FLG                       --重组贷款标识
        ,NULL                                            AS ADJ_BAD_FLG                         --下调为不良标志
        ,NULL                                            AS ALDY_RCMM_FLG                       --曾重组标志
        ,NULL                                            AS CTON_PRD_LOAN_FLG                   --缩期贷款标志
        ,NULL                                            AS CASH_TRF_FLG                        --现转标志
        ,DECODE(H1.DUBIL_ID, NULL,'N', 'Y')              AS FST_LOAN_FLG                        --首贷户贷款标志--20220824 XUXIAOBIN MODIFY
        ,DECODE(H1.DUBIL_ID, NULL,'N', 'Y')              AS FIRST_LOAN_FLG                      --首次贷款标志-20220824 XUXIAOBIN MODIFY
        ,NULL                                            AS PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
        ,'N'                                             AS CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
        ,NULL                                            AS CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
        ,NULL                                            AS LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
        ,CASE WHEN (AD.POVERTY_LOAN_FLG LIKE '%返贫%' OR AD.POVERTY_LOAN_FLG LIKE '%未脱贫%') THEN 'N'
              WHEN (AD.POVERTY_LOAN_FLG LIKE '%已脱贫%' OR AD.POVERTY_LOAN_FLG = '脱贫') THEN 'Y'
              WHEN A.DISTR_DT >= TO_DATE('20210501','YYYYMMDD') AND A.STD_PROD_ID = '202010100003' THEN NULL
              WHEN (A.DISTR_DT > TO_DATE('20211231','YYYYMMDD') AND AC.CUST_ID IS NOT NULL) THEN 'Y'
              ELSE NULL
          END                                            AS ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
        ,NULL                                            AS RATE_RE_PRC_DT                      --利率重新定价日期
        ,CASE WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1D' THEN '01' --按日
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD IN ('7D','1W') THEN '02' --按周
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1M' THEN '03' --按月
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '3M' THEN '04' --按季
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '6M' THEN '05' --按半年
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '12M' THEN '06' --按年
              ELSE '99'
          END                                            AS RATE_FLT_FREQ                      --利率浮动频率
        ,TTK.TAR_VALUE_CODE                              AS RATE_TYP                           --利率类型
        ,NULL                                            AS AST_SCRTZ_PROD_ID                  --资产证券化产品编号
        ,A.EXEC_INT_RAT                                  AS EXEC_RATE                          --执行利率
        ,A.BASE_RAT                                      AS BASE_RATE                          --基准利率
        ,NULL                                            AS CNTR_GUA_LOAN_FLG                  --反担保贷款标志
        ,A.INT_RAT_FLO_VAL                               AS RATE_FLT_VAL                       --利率浮动值
        ,NVL(CONFIG1.PRC_BASE_TYP,TI.TAR_VALUE_CODE)     AS PRC_BASE_TYP                       --定价基准类型
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
               AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷债权直转的取原始总期限
               AND A.INIT_TOT_PERDS <> 0
              THEN A.INIT_TOT_PERDS
              --MOD BY LIP 20240704 网商贷3.0
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.REGROUP_FLG = '1'
              THEN B.REPAY_PERDS
              WHEN A.TOT_PERDS = 0
                /*OR (A.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')  AND TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101'))--MOD BY LIP 20230705 销户日期有默认值00010101*/ --MOD BY YJY 20250206
              THEN A.CURR_ISSUE_PERDS
              WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS
              THEN A.TOT_PERDS + 1
              ELSE A.TOT_PERDS
          END                                            AS TOT_PRD_NUM                        --总期数
        --MOD BY 20240104 微粒贷部分根据还款计划的下期还款时间判断当前期数
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006','202010100008','202020100003')
              THEN B.WLD_CURR_PERDS
              ELSE B.CURR_PERDS
          END                                            AS CURR_PRD                           --当前期数
        ,NVL(B.LJQKQS,0)                                 AS CUM_DEBT_PRD_NUM                   --累计欠款期数
        ,NVL(B.LXQKQS,0)                                 AS CNU_DEBT_PRD_NUM                   --连续欠款期数
        --MOD BY LIP 20240704 网商贷3.0
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.REGROUP_LOAN_TYPE_CD = '0010'
              THEN 1 --0010还款计划变更+展期
              /*WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS
              THEN 1*/  --MOD BY YJY 20250928 与张家伟确认，除了有展期标志的，其他的不算展期
              ELSE 0
          END                                            AS EXTN_CNT                           --展期次数
        ,'01'                                            AS DSBR_MODE                          --放款方式
        ,TTE.TAR_VALUE_CODE                              AS INT_CALC_MODE                      --计息方式
        ,NULL                                            AS MRGN_PCT                           --保证金比例
        ,NULL                                            AS MRGN_CUR                           --保证金币种
        ,NULL                                            AS MRGN                               --保证金
        ,NULL                                            AS MRGN_ACC                           --保证金账号
        ,CASE WHEN TRIM(A.CUST_MGR_ID) IS NOT NULL
              THEN TRIM(A.CUST_MGR_ID)  --modify by tangan at 20230103
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
              THEN '00200423'  --网商贷 杨光泽
              ELSE '00100673' --梁秋茹
          END                                            AS LOAN_OFR_NO                        --信贷员工号 --如果为空，默认为梁秋茹
        ,A.CURRT_ACRU_INT                                AS ACCRD_INT                         --应计利息
        ,NULL                                            AS PRO_IMPT                          --减值准备
        ,NULL                                            AS COM_PRO                           --一般准备
        ,NULL                                            AS SPCL_PRO                          --专项准备
        ,NULL                                            AS ESP_PRO                           --特别准备
        ,NULL                                            AS SPCL_LOAN_FLG                     --专项贷款标志
        ,NULL                                            AS ORIG_RCPT_NO                      --原借据号
         --MOD BY LIP 20230915 根据吴楚非的口径调整网商贷的出资比例
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00'
               AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN 100 --债权直转的出资比例 100
              --MOD BY LIP 20240717 根据业务提供的表格增加3.0、100%出资（有保）的出资比例取数
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.LOAN_TYPE_CD = '14121210' --均衡联营-直投-增信
               AND A.DISTR_DT >= TO_DATE('20230426','YYYYMMDD')
              THEN 100 --100%出资（有保）比例 100
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.LOAN_TYPE_CD = '15121200' --助贷3.0-直投-信用
              THEN 100 --助贷3.0的出资比例 100
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.GUAR_WAY_CD = 'D' --信用
               AND A.DISTR_DT >= TO_DATE('20180901','YYYYMMDD')
               AND A.DISTR_DT < TO_DATE('20190901','YYYYMMDD') --日期带时间戳，用小于下一天
              THEN 90
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.GUAR_WAY_CD = 'D' --信用
               AND A.DISTR_DT >= TO_DATE('20190901','YYYYMMDD')
               AND A.DISTR_DT < TO_DATE('20201208','YYYYMMDD')
              THEN 100
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.GUAR_WAY_CD = 'D' --信用
               AND A.DISTR_DT >= TO_DATE('20201208','YYYYMMDD')
               AND A.DISTR_DT < TO_DATE('20211125','YYYYMMDD')
              THEN 90
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.GUAR_WAY_CD = 'D' --信用
               AND A.DISTR_DT >= TO_DATE('20211125','YYYYMMDD')
               AND A.DISTR_DT < TO_DATE('20230412','YYYYMMDD')
              THEN 65
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.GUAR_WAY_CD = 'D' --信用
               AND A.DISTR_DT >= TO_DATE('20230412','YYYYMMDD')
              THEN 70
              WHEN A.STD_PROD_ID IN ('202020200004')
               AND A.GUAR_WAY_CD = 'C' --保证 网商贷（引流贷）
               AND A.DISTR_DT >= TO_DATE('20230930','YYYYMMDD') --助贷2.0
              THEN 100
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
               AND A.GUAR_WAY_CD = 'C' --保证
               AND A.DISTR_DT >= TO_DATE('20230101','YYYYMMDD')
              THEN 70
              --ADD BY YJY 20250103 新增字节小微贷出资比例判断 --mod by yjy 20250613 新增字节放心借产品
              WHEN A.STD_PROD_ID IN ('202020200001','202010200009','202010200010'
                                    ,'202010200011','202010100007','201020100063'--mod by yjy 20250717 新增分期乐系列产品、唯品消金
                                    ,'202010100009','202020100002')--mod by yjy 20260106 新增202010100009富民联合贷消费、202020100002富民联合贷经营
              THEN A.BANK_CONTRI_RATIO * 100
              ELSE HZF.BHCZBL * 100
          END                                            AS FND_PCT                            --出资比例
        ,TRIM(A.ENTER_ACCT_ACCT_NUM)                     AS ETR_ACC                            --入账账号
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
                OR TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL
              THEN NVL(TRIM(T9.RECVBL_ACCT_NAME),E.CUST_NAME) --MOD BY LIP 20230527 网商贷优先取网商贷借据表中的收款账户名称
          END                                            AS ETR_ACC_NM                         --入账账号户名
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006','202010100008','202020100003')
               AND TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL
              THEN '微信'
              WHEN A.STD_PROD_ID IN ('202010100004')
              THEN '京东'  --modify by hulj 20221107 更改标准产品编号
              --ADD BY YJY 20250103 字节小微贷产品取信贷系统的入账银行名称  --mod by yjy 20250613 新增字节放心借产品
              WHEN A.STD_PROD_ID  IN ('202020200001','202010200009','202010200010'
                                      ,'202010200011','202010100007','201020100063'--mod by yjy 20250717 新增分期乐系列产品、唯品消金
                                      ,'202010100009','202020100002')--mod by yjy 20260106 新增202010100009富民联合贷消费、202020100002富民联合贷经营
              THEN A.ENTER_ACCT_BANK_NAME
              WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL
              THEN '支付宝'
          END                                            AS LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
        ,CASE WHEN TRIM(A.REPAY_NUM) IS NOT NULL
              THEN TRIM(A.REPAY_NUM)
              ----MOD BY YJY 20250103 字节小微贷产品取信贷系统的还款账号  --mod by yjy 20250613 新增字节放心借产品
              WHEN A.STD_PROD_ID  IN ('202020200001','202010200009','202010200010'
                                      ,'202010200011','202010100007','201020100063'--mod by yjy 20250717 新增分期乐系列产品、唯品消金
                                      ,'202010100009','202020100002')--mod by yjy 20260106 新增202010100009富民联合贷消费、202020100002富民联合贷经营
               AND TRIM(A.REPAY_NUM) IS NOT NULL
              THEN NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM))
              ELSE TRIM(A.ENTER_ACCT_ACCT_NUM)
          END                                            AS REPY_ACC                           --还款账号
        ,CASE WHEN A.STD_PROD_ID IN ('202010100006','202010100008','202020100003')
               AND NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM)) IS NOT NULL
              THEN NVL(TRIM(T8.APOT_REPAY_BANK_NAME),'微信')
              WHEN A.STD_PROD_ID IN ('202010100004')
              THEN '京东'  --modify by hulj 20221107 更改标准产品编号
              --MOD BY YJY 20250103 字节小微贷产品取信贷系统的还款银行名称   --mod by yjy 20250613 新增字节放心借产品
              WHEN A.STD_PROD_ID IN ('202020200001','202010200009','202010200010'
                                     ,'202010200011','202010100007','201020100063'--mod by yjy 20250717 新增分期乐系列产品、唯品消金
                                     ,'202010100009','202020100002')--mod by yjy 20260106 新增202010100009富民联合贷消费、202020100002富民联合贷经营
               AND NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM)) IS NOT NULL --MOD BY  YJY 20250609 对还款账号和入账账号都进行不为空的判断
              THEN NVL(A.REPAY_OPEN_ACCT_ORG_NAME,A.ENTER_ACCT_BANK_NAME)
              WHEN NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM)) IS NOT NULL
              THEN '支付宝'
          END                                            AS LOAN_REPY_ACC_OPEN_BANK_NM         --贷款还款账号开户行名称
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 'C0201'  --modify by tangan at 20230103 优先判断核销
              --MOD BY LIP 20240806 调整借据状态取数口径
              WHEN A.CONT_STATUS_CD = 'NORMAL' THEN 'A'   --正常
              WHEN A.CONT_STATUS_CD = 'OVD' THEN 'B'   --逾期
              WHEN A.CONT_STATUS_CD = 'CLEAR' THEN 'C01'   --结清
              WHEN A.OVDUE_FLG = '1' THEN 'B'
              ELSE TTF.TAR_VALUE_CODE
          END                                            AS RCPT_STAT                          --借据状态
        ,CASE WHEN A.CONT_STATUS_CD = 'NORMAL' THEN '01'   --正常
              WHEN A.CONT_STATUS_CD = 'OVD' THEN '01'   --逾期
              WHEN A.CONT_STATUS_CD = 'CLEAR' THEN '02'   --结清
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) = 0
                   AND TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN '02'
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) > 0
              THEN '01'
              ELSE TTG.TAR_VALUE_CODE
          END                                            AS ACC_STAT                            --账户状态
         /*,CASE WHEN A.STD_PROD_ID IN ('202020100003'\*,'202020200004','202020100001'*\) THEN 'Y'
              ELSE 'N' --应吴楚菲要求，因网商贷业务模式已调整为单笔单批，需将其循环贷标识改为“否”
          END */    -- 202020100003-微粒贷 修改为非循环贷  20241028
        ,'N'                                             AS REV_LOAN_FLG                        --循环贷贷款标志 mod by hulj20230818
        ,NULL                                            AS REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
        ,CASE WHEN A.STD_PROD_ID IN ('202010100001','202010100003')
              THEN NVL(A.BANK_CONTRI_RATIO,1)*100 --蚂蚁借呗、花呗
              WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
              THEN 100 --网商贷、网商贷（引流业务）
              WHEN A.STD_PROD_ID IN ('202010100006','202020100003','202010100008')
              THEN NVL(A.BANK_CONTRI_RATIO,1)*100 --微粒贷
              ELSE 90 --京东金融
          END                                            AS BEAR_OR_RED_AMT                      --承担或减免的信贷费用金额
        ,'Y'                                             AS BIO_LOAN_FLG                        --境内外标志
        ,NULL                                            AS DEPT_LINE                           --部门条线
        --,'联合网贷'                                      AS DATA_SRC                            --数据来源
        ,CASE WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
              THEN '零售贷款'
              ELSE '联合网贷'
          END                                            AS DATA_SRC                            --数据来源 --MOD BY YJY 20251104 分期乐、微业贷3.0是按照t-1记账，把分期乐放在零售贷款中
        ,A.DUBIL_ID                                      AS LMT_CONT_ID                         --额度合同编号
        ,A.REPAY_WAY_CD                                  AS GXH_PAY_TYPE                        --还款方式
        ,A.PRIC_REPAY_FREQ_CD                            AS GXH_PAY_FREQ                        --还款频度
        ,'Y'                                             AS LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_INT,0)
          END                                            AS OVD_INT_BAL                         --逾期利息金额
        ,'N'                                             AS REFAC_FLG                           --支小再贷款标识
        ,NULL                                            AS BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
        ,NULL                                            AS LOAN_MODAL_CD                       --贷款形态代码
        ,NULL                                            AS OPER_ORG_ID                         --经办机构编号
        ,NULL                                            AS OPER_TELLER_ID                      --经办柜员编号
        ,H2.LOAN_ACT_DSTR_DT                             AS LOAN_ACT_FIRST_DT                   --本行首贷日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                    AS RENEW_EXP_DAY                       --展期到期日期
        ,TO_CHAR(TFF.FIR_WRT_OFF_DT ,'YYYYMMDD')         AS CNCL_DT                             --核销日期
        ,A.INT_RAT_ADJ_WAY_CD                            AS FIXED_INT_MARK                      --利率是否固定
        ,A.IN_BS_INT                                     AS IN_BS_INT                           --表内利息
        ,A.OFF_BS_INT                                    AS OFF_BS_INT                          --表外利息
        ,A.INIT_TOT_PERDS                                AS HOLD_DAYS                           --持票天数
        ,A.DISTR_AMT                                     AS DISTR_AMT                           --放款金额
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                  AS DISTR_DT                            --放款日期
        ,CASE --MOD BY YJY 20251104 对分期乐、好企贷-数据贷（微业贷3.0）产品特殊处理
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') 
               AND A.WRT_OFF_FLG = '1'
               AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD') 
                   OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE)
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过且核销日期大于月初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') 
               AND A.WRT_OFF_FLG = '1'  
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过的且核销日期小于月初的
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND (A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR A.PAYOFF_DT >= V_MONTH_START_DATE)     
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期为空，或者结清日期大于月初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND A.PAYOFF_DT < V_MONTH_START_DATE 
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期小于月初
              WHEN A.STD_PROD_ID IN ('202010100004')
               AND V_P_DATE > '20240601'
              THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
              WHEN A.STD_PROD_ID IN ('202010100004')
               AND A.WRT_OFF_FLG = '1'
               AND TFF.DUBIL_ID IS NULL
              THEN 'N'
              WHEN A.WRT_OFF_FLG = '1'
               AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE - 1)
              THEN 'Y' --核销过且核销日期大于月初
              WHEN A.WRT_OFF_FLG = '1'
              THEN 'N' --核销过的且核销日期小于月初的
              WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                OR (A.PAYOFF_DT >= V_MONTH_START_DATE - 1
                   AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
              THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
              WHEN A.PAYOFF_DT < V_MONTH_START_DATE - 1
               AND A.STD_PROD_ID NOT IN ('202010100004')
              THEN 'N' --非京东的结清日期小于月初
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
              THEN 'Y' --京东的有余额
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                   AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                        OR A.LAST_REPAY_DT >= V_MONTH_START_DATE - 1)
              THEN 'Y'
              ELSE 'N'
          END                                            AS EAST_FLG                            --EAST口径标识
        ,NULL                                            AS CTR_NT_ID                           --成交单编号
        ,A.RECVBL_PNLT                                   AS RECVBL_PNLT                         --应收罚息
        ,NULL                                            AS COLL_PNLT                           --催收罚息
        ,NULL                                            AS RECVBL_COMP_INT                     --应收复息
        ,NULL                                            AS RECVBL_INT_SUB                      --应收贴息
        ,NULL                                            AS RECVBL_FINE                         --应收罚金
        ,A.RECVBL_OVER_INT                               AS RECVBL_OVER_INT                     --应收欠息
        ,NULL                                            AS COLL_OVER_INT                       --催收欠息
        ,NULL                                            AS LOAN_USEAGE_SUB_CL                  --贷款用途细类
        ,CASE WHEN A.CUST_CHAR_CD = '01' THEN '个体工商户'
              WHEN A.CUST_CHAR_CD = '02' THEN '小微企业主'
              WHEN A.CUST_CHAR_CD = '03' THEN '其他'
              WHEN A.CUST_CHAR_CD = '04' THEN '大中型企业主'
              WHEN A.CUST_CHAR_CD = '05' THEN '其他非企业负责人'
              WHEN A.CUST_CHAR_CD = '06' THEN '其他无营业执照负责人'
          END                                            AS CUST_CHAR                           --客户性质
        ,NULL                                            AS OUT_ACCT_FLOW_NUM                   --出账流水号
        ,T6.INDTYPE                                      AS INDTYPE                             --联合网贷客户性质
        ,A.CUST_ID                                       AS ICMS_CUST_ID                        --信贷客户编号
        ,A.INTNAL_CARR_FLG                               AS INTNAL_CARR_FLG                     --内部结转标志
        ,A.BASE_RAT                                      AS BASE_RAT_IMAS                       --基准利率IMAS --ADD BY LIP 20230810
        ,A.CRED_RHT_TURN_FLG                             AS CRED_RHT_TURN_FLG                   --债权直转标志 ADD BY HULJ20230914
        ,A.LOAN_TYPE_CD                                  AS LOAN_TYPE_CD                        --借据类型代码 ADD BY HULJ20230914
        --MOD BY 20240103
        ,CASE WHEN A.INIT_DISTR_AMT = 0
              THEN A.ACP_DISTR_AMT
              ELSE A.INIT_DISTR_AMT
          END                                            AS INIT_DISTR_AMT                      --原始放款金额
        ,TO_CHAR(A.INIT_DISTR_DT,'YYYYMMDD')             AS INIT_DISTR_DT                       --原始放款日期 ADD BY LIP 20230925
        ,A.INIT_TOT_PERDS                                AS INIT_TOT_PERDS                      --原始总期数 ADD BY LIP 20230925
        ,A.CURR_ISSUE_PERDS                              AS INIT_CURR_PRD                       --原始当前期数 ADD BY LIP 20230925
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
              THEN A.REGROUP_FLG
              ELSE '0'
          END                                            AS REGROUP_LOAN_FLG                    --重组贷款标志 ADD BY LIP 20240704
        ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
              THEN A.REGROUP_LOAN_TYPE_CD
              ELSE NULL
          END                                            AS REGROUP_LOAN_TYPE_CD                --重组贷款类型代码 ADD BY LIP 20240704
        ,T9.HAPP_WAY_CD                                  AS HAPP_WAY_CD                         --发生方式代码  ADD BY YJY 20241010
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')                 AS PAYOFF_DT                           --结清日期 -- ADD  BY YJY 20241022
        ,NULL                                            AS SUIT_FEE_BAL                        --诉讼费余额     --ADD BY YJY 20241217
        ,NULL                                            AS ISWHITE_FLG                         --白户标志       --ADD BY LAL 20250904
        ,NULL                                            AS GREEN_CRDT_CLS_NEW                  --绿色信贷分类_新版代码 --ADD BY YJY 20250508
        ,CASE  --MOD BY YJY 20251104 BEGIN 对分期乐、好企贷-数据贷（微业贷3.0）产品特殊处理
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') 
               AND A.WRT_OFF_FLG = '1'
               AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD') 
                   OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE)
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过且核销日期大于年初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') 
               AND A.WRT_OFF_FLG = '1'  
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过的且核销日期小于年初的
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND (A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR A.PAYOFF_DT >= V_YEAR_START_DATE)     
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期为空，或者结清日期大于年初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND A.PAYOFF_DT < V_YEAR_START_DATE 
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期小于年初 
              WHEN A.STD_PROD_ID IN ('202010100004')
               AND V_P_DATE > '20240601'
              THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
              WHEN A.STD_PROD_ID IN ('202010100004')
               AND A.WRT_OFF_FLG = '1'
               AND TFF.DUBIL_ID IS NULL
              THEN 'N'
              WHEN A.WRT_OFF_FLG = '1'
               AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE - 1)
              THEN 'Y' --核销过且核销日期大于年初
              WHEN A.WRT_OFF_FLG = '1'
              THEN 'N' --核销过的且核销日期小于年初的
              WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                OR (A.PAYOFF_DT >= V_YEAR_START_DATE - 1
                   AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
              THEN 'Y' --结清日期为空，或者非京东的结清日期大于年初
              WHEN A.PAYOFF_DT < V_YEAR_START_DATE - 1
               AND A.STD_PROD_ID NOT IN ('202010100004')
              THEN 'N' --非京东的结清日期小于年初
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) > 0
              THEN 'Y' --京东的有余额
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) + NVL(A.OFF_BS_INT,0) + NVL(A.BAD_DEBT_PRIC,0) = 0
                   AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                        OR A.LAST_REPAY_DT >= V_YEAR_START_DATE - 1)
              THEN 'Y'
              ELSE 'N'
          END                                            AS YBT_FLG     --一表通口径标识--ADDBY PSF 20250916
      ,NULL                                            AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
      ,NULL                                            AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
      ,NULL                                            AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
   FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
   LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO M --标准产品信息
     ON M.PROD_ID = STD_PROD_ID
    AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   /* LEFT JOIN UNITE_WL_REPAY_PLAN_1 B --还款计划 取连续/累计欠款期数
     ON B.DUBIL_ID = A.DUBIL_ID */
   -- MOD BY YJY 20251104  从临时表取值
   LEFT JOIN RRP_MDL.M_LOAN_DUBILL_UNITE_WL_REPAY_PLAN_TMP B  --还款计划 取连续/累计欠款期数
     ON B.DUBIL_ID = A.DUBIL_ID
    AND B.PROD_ID NOT IN ('203050100001' ,'203050100002')--剔除微业贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
   LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO E --个人客户基本信息
     ON E.CUST_ID = A.CUST_ID
    AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H C --当事人物理地址历史
     ON C.PARTY_ID = A.CUST_ID
    AND C.SRC_SYS_CD = 'EIFS'
    AND C.PHYS_ADDR_TYPE_CD = /*'003001'*/ '01' --居住地  MOD BY YJY 20260119
    AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IOL_ICMS_CUSTOMER_INFO_LHDK T6 --联合网贷客户信息
     ON T6.CUSTOMERID = A.CUST_ID
    AND T6.START_DT <= A.ETL_DT -1
    AND T6.END_DT > A.ETL_DT -1
   LEFT JOIN RRP_MDL.O_IML_AGT_WLD_DUBIL_INFO T7 --微粒贷借据
     ON T7.DUBIL_ID = A.DUBIL_ID
   LEFT JOIN RRP_MDL.O_IML_AGT_WLD_ACCT T8 --微粒贷账户 --MOD BY LIP 20230527
     ON T8.ACCT_ID = T7.ACCT_ID
    AND T8.ACCT_TYPE_CD = T7.ACCT_TYPE_CD
   LEFT JOIN RRP_MDL.O_IML_AGT_MYLOAN_DUBIL T9 --网商贷借据 --MOD BY LIP 20230527
     ON T9.DUBIL_ID = A.DUBIL_ID
    AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO TFF --联合网贷核销信息
     ON TFF.DUBIL_ID = A.DUBIL_ID
    AND TFF.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP04 AC --精准扶贫按客户整合
     ON AC.CUST_ID = A.CUST_ID
    AND AC.ACCT_DURAN = '2021-04'
   LEFT JOIN RRP_MDL.ADD_POVERTY_RELIF AD --精准扶贫名录20211231填报数据基表
     ON AD.LOAN_NUM = A.DUBIL_ID
   LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD PUB --公共代码表 取贷款用途
     ON PUB.CD_ID = 'CD1274'
    AND PUB.CD_VAL = A.LOAN_USAGE_CD
   LEFT JOIN RRP_MDL.CODE_MAP TTA   --码值映射表(贷款类型)
     ON TTA.SRC_VALUE_CODE = A.STD_PROD_ID
    AND TTA.SRC_CLASS_CODE = 'STD0002'
    AND TTA.TAR_CLASS_CODE = 'T0001'
    AND TTA.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTB   --码值映射表(贷款用途)
     ON TTB.SRC_VALUE_CODE = A.LOAN_USAGE_CD
    AND TTB.SRC_CLASS_CODE = 'CD1274'
    AND TTB.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTC   --码值映射表(五级形态)
     ON TTC.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
    AND TTC.SRC_CLASS_CODE = 'CD1032'
    AND TTC.TAR_CLASS_CODE = 'D0005'
    AND TTC.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTD   --码值映射表(还款方式)
     ON TTD.SRC_VALUE_CODE = A.INT_SET_WAY_CD
    AND TTD.SRC_CLASS_CODE = 'CD1007'
    AND TTD.TAR_CLASS_CODE = 'D0103'
    AND TTD.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTE   --码值映射表(计息方式)
     ON TTE.SRC_VALUE_CODE = A.INT_SET_WAY_CD
    AND TTE.SRC_CLASS_CODE = 'CD1007'
    AND TTE.TAR_CLASS_CODE = 'D0061'
    AND TTE.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTF   --码值映射表（借据状态）
     ON TTF.SRC_VALUE_CODE = A.DUBIL_STATUS_CD
    AND TTF.SRC_CLASS_CODE = 'CD1261'
    AND TTF.TAR_CLASS_CODE = 'D0007'
    AND TTF.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTG   --码值映射表(账户状态)转码
     ON TTG.SRC_VALUE_CODE = A.DUBIL_STATUS_CD
    AND TTG.SRC_CLASS_CODE = 'CD1261'
    AND TTG.TAR_CLASS_CODE = 'Z0018'
    AND TTG.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TI    --利率种类转码
     ON TI.SRC_VALUE_CODE = A.INT_RAT_BASE_TYPE_CD
    AND TI.SRC_CLASS_CODE = 'CD1010'
    AND TI.TAR_CLASS_CODE = 'Z0015'
    AND TI.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTK   --利率类型转码
     ON TTK.SRC_VALUE_CODE = A.INT_RAT_FLOAT_WAY_CD
    AND TTK.SRC_CLASS_CODE = 'CD1016'
    AND TTK.TAR_CLASS_CODE = 'Z0007'
    AND TTK.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTL  --利率调整频率
     ON TTL.SRC_VALUE_CODE = A.INT_RAT_ADJ_PED_CORP_CD
    AND TTL.SRC_CLASS_CODE = 'CD1041'
    AND TTL.TAR_CLASS_CODE = 'D0105'
    AND TTL.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP TTM  --担保方式转码
     ON TTM.SRC_VALUE_CODE = A.GUAR_WAY_CD
    AND TTM.SRC_CLASS_CODE = 'CD2656'
    AND TTM.TAR_CLASS_CODE = 'D0002'
    AND TTM.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CONFIG_LOAN_PROD CONFIG1
     ON CONFIG1.STD_PROD_ID = A.STD_PROD_ID
   LEFT JOIN (SELECT STD_PROD_ID   AS STD_PROD_ID  --标准产品编号
                    ,MIN(HZFS)     AS HZFS         --合作方式
                    ,MAX(BHCZBL)   AS BHCZBL       --本行出资比例
               FROM RRP_MDL.M_DICT_G09_HZF --G09互联网贷款产品信息静态表
               GROUP BY STD_PROD_ID ) HZF   --ADD BY WEIYONGZHAO 20230523 关联取网贷产品和类别
     ON HZF.STD_PROD_ID = A.STD_PROD_ID
   LEFT JOIN (SELECT DUBIL_ID
                FROM (SELECT B.DUBIL_ID,
                             ROW_NUMBER() OVER(PARTITION BY B.CUST_ID ORDER BY B.DISTR_DT,B.DUBIL_ID ASC) AS RN
                        FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B
                       WHERE B.ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD'))
               WHERE RN = 1) H1  --ADD BY 20220824 XUXIAOBIN  取是否首贷标志
     ON H1.DUBIL_ID = A.DUBIL_ID
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00 H2  --取是否首贷日期 ADD BY 20221122 hulj
     ON H2.RCPT_ID = A.DUBIL_ID
  WHERE A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销
    AND A.DUBIL_ID IS NOT NULL
    AND A.STD_PROD_ID NOT IN ('203050100001','203050100002')--MOD BY YJY 20250213 剔除对公产品203050100001微业贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --金数存保 单位贷款需报送部分 --20220906 xuxiaobin add
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--非标其他债券';
  V_STARTTIME := SYSDATE;
  INSERT/*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP
    (DATA_DT                             --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                             --借据编号
    ,CONT_ID                             --合同编号
    ,BILL_NO                             --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                             --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                             --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                 --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                             --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                     --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                     --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                       --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                         --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                         --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                             --逾期类型
    ,LOAN_USEAGE                         --贷款用途
    ,LVL5_CL                             --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                       --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                   --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                     --房地产贷款标志
    ,IALL_LOAN_FLG                       --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                 --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG               --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG             --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                       --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
    ,REPY_MODE                           --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                       --重组贷款标识
    ,ADJ_BAD_FLG                         --下调为不良标志
    ,ALDY_RCMM_FLG                       --曾重组标志
    ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                       --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
    ,EXEC_RATE                           --执行利率
    ,BASE_RATE                           --基准利率
    ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                         --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                           --放款方式
    ,INT_CALC_MODE                       --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                         --信贷员工号
    ,ACCRD_INT                           --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                             --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                             --特别准备
    ,SPCL_LOAN_FLG                       --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                             --出资比例
    ,ETR_ACC                             --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                           --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                        --境内外标志
    ,DEPT_LINE                           --部门条线
    ,DATA_SRC                            --数据来源
    ,CNTPTY_CUST_ID                      --交易对手客户编号 --ADD BY LYH 20240204
    ,PAYOFF_DT                           --结清日期  --ADD BY YJY 20241022
    ,SUIT_FEE_BAL                        --诉讼费余额     --ADD BY YJY 20241217
    ,GREEN_CRDT_CLS_NEW                  --绿色信贷分类_新版代码 --ADD BY YJY 20250508
    ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    )
  SELECT /*PRALLEL(4)*/ V_P_DATE                                           AS DATA_DT                      --数据日期
        ,A.LP_ID                                                           AS LGL_REP_ID                   --法人编号
        ,A.FIN_INSTM_ID||'.'||A.ASSET_TYPE_ID||'.'||A.MARKET_TYPE_ID       AS ACC_ID                       --账户编号
        ,A.FIN_INSTM_ID                                                    AS RCPT_ID                      --借据编号
        ,A.FIN_INSTM_ID                                                    AS CONT_ID                      --合同编号
        ,NULL                                                              AS BILL_NO                      --票据号码
        ,NULL                                                              AS COOP_AGRT_ID                 --合作协议编号
        ,D.CUST_ID                                                         AS CUST_ID                      --客户编号
        ,A.BELONG_ORG_ID                                                   AS ORG_ID                       --机构编号
        ,A.SUBJ_ID                                                         AS SUBJ_ID                      --科目编号
        ,A.STD_PROD_ID                                                     AS LOAN_STD_PROD_ID             --贷款标准产品编号
        ,A.STD_PROD_ID                                                     AS LOAN_STD_PROD_NM             --贷款标准产品名称
        ,A.STD_PROD_ID                                                     AS LOAN_PROD_ID                 --贷款产品编号
        ,A.STD_PROD_ID                                                     AS LOAN_PROD_NM                 --贷款产品名称
        ,'99'                                                              AS LOAN_BIZ_TYP                 --贷款业务类型
        ,A.CURR_CD                                                         AS CUR                          --币种
        ,A.FAC_VAL_AMT                                                     AS LOAN_AMT                     --借款金额
        ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%'
              THEN NVL(A.BOOK_BAL,0)
              ELSE NVL(A.BOOK_BAL,0) + ROUND(NVL(O.N_PV_VARIATION,0),2)
          END                                                              AS LOAN_BAL                    --贷款余额
        ,0.0000                                                            AS INT_ADJ                     --利息调整
        ,0                                                                 AS FAIR_VAL_CHG                --公允价值变动
        ,''                                                                AS OVD_PRIN_BAL                --逾期本金余额
        ,''                                                                AS IN_INT_OVD_BAL              --表内欠息余额
        ,''                                                                AS OUT_INT_OVD_BAL             --表外欠息余额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                    AS LOAN_ACT_DSTR_DT            --贷款实际发放日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                      AS LOAN_ORIG_EXP_DT            --贷款原始到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                      AS LOAN_ACT_EXP_DT             --贷款实际到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                      AS ACT_END_DT                  --实际终止日期
        ,NULL                                                              AS LAST_REPY_DT                --上次还款日期
        ,NULL                                                              AS LAST_REPY_AMT               --上次还款金额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                    AS VAL_DT                      --起息日期
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                    AS OPEN_ACC_DT                 --开户日期
        , NULL                                                             AS CNL_ACC_DT                  --销户日期
        ,TO_CHAR(A.PRIC_OVDUE_DT,'YYYYMMDD')                               AS PRIN_OVD_DT                 --本金逾期日期
        ,TO_CHAR(A.INT_OVDUE_DT,'YYYYMMDD')                                AS INT_OVD_DT                  --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)                      AS OVD_DAYS                    --逾期天数
        ,NULL                                                              AS OVD_TYP                     --逾期类型
        ,C.USAGE_DESCB                                                     AS LOAN_USEAGE                 --贷款用途
        ,DECODE(A.LEVEL5_CLS_CD,'10','01',/*10正常 20关注 30次级 40可疑*/
                   '20','02','30','03','40','04','50','05')                AS LVL5_CL                     --五级分类
        ,CASE WHEN C.GUAR_WAY_COMB LIKE '%,%' THEN 'E'  --多个码值的为组合担保 E
              WHEN C.GUAR_WAY_COMB = '005' THEN 'D' --005信用，映射为D
              WHEN C.GUAR_WAY_COMB = '010' THEN 'C' --010保证映射为C
              WHEN SUBSTR(C.GUAR_WAY_COMB,1,3) = '010' AND LENGTH(C.GUAR_WAY_COMB) > 3 THEN 'C99'--细项默认可为C99
              WHEN C.GUAR_WAY_COMB = '020' THEN 'B'--020抵押B
              WHEN SUBSTR(C.GUAR_WAY_COMB,1,5) = '02010' THEN 'B01'--02010开头的细项默认为B01
              WHEN SUBSTR(C.GUAR_WAY_COMB,1,3) = '020' AND LENGTH(C.GUAR_WAY_COMB) > 3 THEN 'B99'--细项默认为B99
              WHEN SUBSTR(C.GUAR_WAY_COMB,1,2) IN ('30','04','05')  AND LENGTH(C.GUAR_WAY_COMB) > 3 THEN 'A'--质押或保证金，映射为A
              ELSE 'D'
          END                                                              AS GUA_MODE                    --担保方式
        ,NULL                                                              AS LOAN_DIR_RGN                --贷款投向地区
        ,TX.BUSINESS_CATEGORY_MID                                          AS LOAN_DIR_IDY                --贷款投向行业 20221124 XUXIAOBIN MODIFY JS
        ,NULL                                                              AS SYN_LOAN_FLG                --银团贷款标志
        ,CASE WHEN A.STD_PROD_ID IN ('203010200003','203010200004','203010200005','203010200006')
              THEN 'Y'
              ELSE 'N'
          END                                                              AS PROJ_LOAN_FLG               --项目贷款标志
        ,NULL                                                              AS IDY_STRU_ADJ_TYP            --产业结构调整类型
        ,NULL                                                              AS IDY_TRNST_UPG_FLG           --工业转型升级标志
        ,NULL                                                              AS STRTG_EMER_IDY_TYP          --战略新兴产业类型
        ,'N'                                                               AS BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
        ,NULL                                                              AS AGR_REL_LOAN_FLG            --涉农贷款标志
        ,NULL                                                              AS RL_EST_LOAN_FLG             --房地产贷款标志
        ,NULL                                                              AS IALL_LOAN_FLG               --投贷联动贷款标志
        ,NULL                                                              AS OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
        ,NULL                                                              AS GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
        ,NULL                                                              AS ENT_GUA_LOAN_TYP            --创业担保贷款类型
        ,NULL                                                              AS CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
        ,NULL                                                              AS LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
        ,NULL                                                              AS LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                                              AS FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                                              AS POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
        ,NULL                                                              AS LOAN_HDL_CHAN               --贷款办理渠道
        ,'N'                                                               AS NET_LOAN_FLG                --互联网贷款标志
        ,'0'                                                               AS NET_LOAN_PROD_TYP           --网贷产品类别
        ,NULL                                                              AS CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
        ,NULL                                                              AS REPY_MODE                   --还款方式
        ,NULL                                                              AS LOAN_FRM                    --贷款形式
        ,NULL                                                              AS RCMM_LOAN_FLG               --重组贷款标识
        ,NULL                                                              AS ADJ_BAD_FLG                 --下调为不良标志
        ,NULL                                                              AS ALDY_RCMM_FLG               --曾重组标志
        ,NULL                                                              AS CTON_PRD_LOAN_FLG           --缩期贷款标志
        ,NULL                                                              AS CASH_TRF_FLG                --现转标志
        ,'N'                                                               AS FST_LOAN_FLG                --首贷户贷款标志\
        ,'N'                                                               AS FIRST_LOAN_FLG              --首次贷款标志\
        ,NULL                                                              AS PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
        ,NULL                                                              AS CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
        ,NULL                                                              AS CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
        ,NULL                                                              AS LOAN_FINC_SPT_MODE          --贷款财政扶持方式
        ,NULL                                                              AS ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
        ,NULL                                                              AS RATE_RE_PRC_DT              --利率重新定价日期
        ,NULL                                                              AS RATE_FLT_FREQ               --利率浮动频率
        ,'1'                                                               AS RATE_TYP                    --利率类型
        ,NULL                                                              AS AST_SCRTZ_PROD_ID           --资产证券化产品编号
        ,A.FAC_VAL_INT_RAT                                                 AS EXEC_RATE                   --执行利率
        ,A.BASE_RAT                                                        AS BASE_RATE                   --基准利率
        ,NULL                                                              AS CNTR_GUA_LOAN_FLG           --反担保贷款标志
        ,NULL                                                              AS RATE_FLT_VAL                --利率浮动值
        ,'Z'                                                               AS PRC_BASE_TYP                --定价基准类型
        ,NULL                                                              AS TOT_PRD_NUM                 --总期数
        ,NULL                                                              AS CURR_PRD                    --当前期数
        ,NULL                                                              AS CUM_DEBT_PRD_NUM           --累计欠款期数
        ,NULL                                                              AS CNU_DEBT_PRD_NUM            --连续欠款期数
        ,0                                                                 AS EXTN_CNT                    --展期次数
        ,NULL                                                              AS DSBR_MODE                   --放款方式
        ,NULL                                                              AS INT_CALC_MODE               --计息方式
        ,NULL                                                              AS MRGN_PCT                    --保证金比例
        ,NULL                                                              AS MRGN_CUR                    --保证金币种
        ,NULL                                                              AS MRGN                        --保证金
        ,NULL                                                              AS MRGN_ACC                    --保证金账号
        ,NULL                                                              AS LOAN_OFR_NO                 --信贷员工号
        ,A.ACRU_INT                                                        AS ACCRD_INT                   --应计利息
        ,NULL                                                              AS PRO_IMPT                    --减值准备
        ,NULL                                                              AS COM_PRO                     --一般准备
        ,NULL                                                              AS SPCL_PRO                    --专项准备
        ,NULL                                                              AS ESP_PRO                     --特别准备
        ,NULL                                                              AS SPCL_LOAN_FLG               --专项贷款标志
        ,A.FIN_INSTM_ID                                                    AS ORIG_RCPT_NO                --原借据号
        ,NULL                                                              AS FND_PCT                     --出资比例
        ,A.EXCHG_ACCT_ID                                                   AS ETR_ACC                     --入账账号
        ,A.CNTPTY_NAME                                                     AS ETR_ACC_NM                  --入账账号户名
        ,A.CNTPTY_NAME                                                     AS LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
        ,NULL                                                              AS REPY_ACC                    --还款账号
        ,NULL                                                              AS LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
        ,'A'                                                               AS RCPT_STAT                   --借据状态
        ,NULL                                                              AS ACC_STAT                    --账户状态
        ,NULL                                                              AS REV_LOAN_FLG                --循环贷贷款标志
        ,NULL                                                              AS REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
        ,NULL                                                              AS BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
        ,NULL                                                              AS BIO_LOAN_FLG                --境内外标志
        ,NULL                                                              AS DEPT_LINE                   --部门条线
        ,'非标其他债券'                                                    AS DATA_SRC                    --数据来源
        ,A.CNTPTY_CUST_ID                                                  AS CNTPTY_CUST_ID              --交易对手客户编号 --ADD BY LYH 20240204
        ,NULL                                                              AS PAYOFF_DT                   --结清日期  --ADD BY YJY 20241022
        ,NULL                                                              AS SUIT_FEE_BAL                --诉讼费余额     --ADD BY YJY 20241217
        ,NULL                                                              AS GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
        ,NULL                                                              AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
        ,NULL                                                              AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
        ,NULL                                                              AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
   FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A  --同业非标投资表
   LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A1 -- 同业证券持仓表  总分核对，根据数仓和财务集市总分校验校验，使用的金额是同业证券持仓的数据
     ON A1.FIN_INSTM_ID = A.FIN_INSTM_ID
    AND A1.ASSET_TYPE_ID = A.ASSET_TYPE_ID
    AND A1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
    AND A1.OBJ_ID = A.OBJ_ID
    AND A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_CAP_BAL B  --同业资金余额表
     ON B.INTNAL_CAP_ACCT_ID = A.INTNAL_SECU_ACCT_ID
    AND B.EXT_CAP_ACCT_ID = A.EXT_SECU_ACCT_ID
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C  --同业金融工具表
     ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
    AND C.MARKET_TYPE_ID = A.MARKET_TYPE_ID
    AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
    AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D  --同业交易对手信息
     ON D.SRC_PARTY_ID = C.ISSUE_ORG_ID
    AND D.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --I9估值报告表 取公允价值变动
     ON O.V_ASSET_CODE = A.FIN_INSTM_ID
    AND O.V_THREE_CLASS = A.ASSET_THD_CLS_CD
    AND O.V_TRADE_NO = A.OBJ_ID
    AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE TX --20221124 许晓滨 取投向中类，金数部分
     ON TX.I_CODE = A.FIN_INSTM_ID
    AND TX.A_TYPE = A.ASSET_TYPE_ID
    AND TX.M_TYPE = A.MARKET_TYPE_ID
    AND TX.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TX.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  WHERE A.VALUE_DT > DATE '2021-11-01'
    AND (A.ASSET_TYPE_NAME IN ('北金所债权融资计划','券商固定收益凭证','类信贷-可转债','私募债')
         OR A.STD_PROD_ID IN ('307010100001','307020100001','307020100002','307030100001'))--20230302与陆炜迪确认
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--对公贷款贴现部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP
    (DATA_DT                             --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                             --借据编号
    ,CONT_ID                             --合同编号
    ,BILL_NO                             --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                             --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                             --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                 --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                             --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                     --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                     --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                       --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                         --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                         --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                             --逾期类型
    ,LOAN_USEAGE                         --贷款用途
    ,LVL5_CL                             --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                       --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                   --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                     --房地产贷款标志
    ,IALL_LOAN_FLG                       --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                 --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG               --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG             --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                       --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
    ,REPY_MODE                           --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                       --重组贷款标识
    ,ADJ_BAD_FLG                         --下调为不良标志
    ,ALDY_RCMM_FLG                       --曾重组标志
    ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                       --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
    ,EXEC_RATE                           --执行利率
    ,BASE_RATE                           --基准利率
    ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                         --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                           --放款方式
    ,INT_CALC_MODE                       --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                         --信贷员工号
    ,ACCRD_INT                           --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                             --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                             --特别准备
    ,SPCL_LOAN_FLG                       --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                             --出资比例
    ,ETR_ACC                             --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                           --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                        --境内外标志
    ,DEPT_LINE                           --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,ASSET_TRAN_DT                       --资产转让日期
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 ADD BY HULJ 20221123
    ,OPER_TELLER_ID                      --经办柜员编号 ADD BY HULJ 20221123
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 ADD BY HULJ 20221123
    ,RENEW_EXP_DAY                       --展期到期日期 ADD BY HULJ 20221123
    ,FIR_LON_DT                          --征信首贷日期 ADD BY HULJ 20221123
    ,LOAN_MGR_ID                         --借据主办客户经理号 ADD BY HULJ 20221123
    ,LOAN_TELLER_ID                      --借据主办柜员号 ADD BY HULJ 20221123
    ,LOAN_MGR_NAME                       --借据主办客户经理名称 ADD BY HULJ 20221123
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构 ADD BY HULJ 20221123
    ,DISCNT_CUST_ID                      --直贴人客户编号
    ,HOLD_DAYS                           --持票天数
    ,DISTR_AMT                           --放款金额
    ,DISTR_DT                            --放款日期
    ,EAST_FLG                            --EAST_口径标识
    ,CTR_NT_ID                           --成交单编号
    ,RECVBL_PNLT                         --应收罚息
    ,COLL_PNLT                           --催收罚息
    ,RECVBL_COMP_INT                     --应收复息
    ,RECVBL_INT_SUB                      --应收贴息
    ,RECVBL_FINE                         --应收罚息
    ,RECVBL_OVER_INT                     --应收欠息
    ,COLL_OVER_INT                       --催收欠息
    ,TENOR                               --剩余期限
    ,LOAN_USEAGE_SUB_CL                  --贷款用途细类
    ,CUST_CHAR                           --客户性质
    ,OUT_ACCT_FLOW_NUM                   --出账流水号
    ,ICMS_CUST_ID                        --信贷客户编号
    ,HXB_ACPT_FLG                        --我行承兑标识
    ,BILL_SUB_INTRV_ID                   --子票据区间编号
    ,PAYOFF_DT                           --结清日期    --ADD BY YJY 20241022
    ,SUIT_FEE_BAL                        --诉讼费余额  --ADD BY YJY 20241217
    ,BILL_NUM                            --票据编码    --ADD BY YJY 20250410
    ,GREEN_CRDT_CLS_CD                   --绿色信贷分类_旧版代码 --ADD BY LIP 20251013
    ,GREEN_CRDT_CLS_NEW                  --绿色信贷分类_新版代码 --ADD BY YJY 20250508
    ,YBT_FLG                             --一表通口径标识 --ADD BY PSF 20250916
    ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    ,ACTL_AMT                            --实付金额 ADD BY YJY 20260324
    )
    WITH DEPOSIT_APPLY_INFO AS ( --ADD BY LIP 20251104 
  SELECT /*+MATERIALIZE*/TA.*,ROW_NUMBER() OVER(PARTITION BY TA.CONTRACTNO ORDER BY TA.EXCHANGEDATE,TA.PUTOUTNO) RN
    FROM RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO TA --保证金流水追加表
   WHERE TA.APPROVESTATUS = 'Finished'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')                AS DATA_DT                     --数据日期
         ,A.LP_ID                                     AS LGL_REP_ID                  --法人编号
         ,B.DUBIL_ID                                  AS ACC_ID                      --账户编号
         ,B.DUBIL_ID                                  AS RCPT_ID                     --借据编号
         ,B.CONT_ID                                   AS CONT_ID                     --合同编号
         ,A.BILL_ID                                   AS BILL_NO                     --票据号码 20220420改为票据唯一ID
         ,NULL                                        AS COOP_AGRT_ID                --合作协议编号
         ,B.CUST_ID                                   AS CUST_ID                     --客户编号
         ,A.ENTER_ACCT_ORG_ID                         AS ORG_ID                      --机构编号
         ,A.SUBJ_ID                                   AS SUBJ_ID                     --科目编号
         ,B.STD_PROD_ID                               AS LOAN_STD_PROD_ID            --贷款标准产品编号
         ,M.PROD_NAME                                 AS LOAN_STD_PROD_NM            --贷款标准产品名称
         ,B.STD_PROD_ID                               AS LOAN_PROD_ID                --贷款产品编号
         ,M.PROD_NAME                                 AS LOAN_PROD_NM                --贷款产品名称
         ,NVL(TTA.TAR_VALUE_CODE,B.STD_PROD_ID)       AS LOAN_BIZ_TYP                --贷款业务类型
         ,A.CURR_CD                                   AS CUR                         --币种
         ,A.FAC_VAL_AMT                               AS LOAN_AMT                    --借款金额
         ,CASE WHEN B.PAYOFF_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN ROUND((NVL(A.CURRT_BAL,0)),2)
               ELSE 0
           END                                        AS LOAN_BAL                    --贷款余额
         ,NVL(A.INT_ADJ_BAL,0)                        AS INT_ADJ                     --利息调整
         ,NVL(O.N_PV_VARIATION,0)                     AS FAIR_VAL_CHG                --公允价值变动
         ,NULL                                        AS OVD_PRIN_BAL                --逾期本金余额
         ,NULL                                        AS IN_INT_OVD_BAL              --表内欠息余额
         ,NULL                                        AS OUT_INT_OVD_BAL             --表外欠息余额
         ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')              AS LOAN_ACT_DSTR_DT            --贷款实际发放日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                AS LOAN_ORIG_EXP_DT            --贷款原始到期日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                AS LOAN_ACT_EXP_DT             --贷款实际到期日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        AS ACT_END_DT                  --实际终止日期
         ,NULL                                        AS LAST_REPY_DT                --上次还款日期
         ,NULL                                        AS LAST_REPY_AMT               --上次还款金额
         ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')              AS VAL_DT                      --起息日期
         ,TO_CHAR(A.APPL_DT,'YYYYMMDD')               AS OPEN_ACC_DT                 --开户日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101')
               THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        AS CNL_ACC_DT                  --销户日期
         ,NULL                                        AS PRIN_OVD_DT                 --本金逾期日期
         ,NULL                                        AS INT_OVD_DT                  --利息逾期日期
         ,NULL                                        AS OVD_DAYS                    --逾期天数
         ,CASE WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
               WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
               WHEN C.PRIC_OVDUE_DAYS = 0 AND C.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
               ELSE NULL
           END                                        AS OVD_TYP                     --逾期类型
         ,H.LOAN_USAGE_DESCB                          AS LOAN_USEAGE                 --贷款用途
         ,TB.TAR_VALUE_CODE                           AS LVL5_CL                     --五级分类
         ,B.GUAR_WAY_CD                               AS GUA_MODE                    --担保方式
         ,CASE WHEN TRIM(E.RG_CD) NOT IN ('1000','999999','000000')
               THEN TRIM(E.RG_CD)
               WHEN TRIM(F.DIST_CD) NOT IN ('1000','999999','000000')
               THEN TRIM(F.DIST_CD)
           END                                        AS LOAN_DIR_RGN                --贷款投向地区
         ,CASE WHEN B.DIR_INDUS_CD = '-'
               THEN 'Z'
               ELSE NVL(B.DIR_INDUS_CD,'Z')
           END                                        AS LOAN_DIR_IDY                --贷款投向行业
         ,NULL                                        AS SYN_LOAN_FLG                --银团贷款标志
         ,NULL                                        AS PROJ_LOAN_FLG               --项目贷款标志
         ,NULL                                        AS IDY_STRU_ADJ_TYP            --产业结构调整类型
         ,NULL                                        AS IDY_TRNST_UPG_FLG           --工业转型升级标志
         ,NULL                                        AS STRTG_EMER_IDY_TYP          --战略新兴产业类型
         ,'N'                                         AS BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
         ,'N'                                         AS AGR_REL_LOAN_FLG            --涉农贷款标志
         ,NULL                                        AS RL_EST_LOAN_FLG             --房地产贷款标志
         ,NULL                                        AS IALL_LOAN_FLG               --投贷联动贷款标志
         ,NULL                                        AS OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
         ,NULL                                        AS GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
         ,NULL                                        AS ENT_GUA_LOAN_TYP            --创业担保贷款类型
         ,NULL                                        AS CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
         ,NULL                                        AS LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
         ,NULL                                        AS LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
         ,NULL                                        AS FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
         ,NULL                                        AS POV_ALLE_REC_FLG            --建档立卡贫困人口贷款标志
         ,NULL                                        AS LOAN_HDL_CHAN               --贷款办理渠道
         ,'N'                                         AS NET_LOAN_FLG                --互联网贷款标志
         ,'0'                                         AS NET_LOAN_PROD_TYP            --网贷产品类别
         ,NULL                                        AS CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
         ,'9914'                                      AS REPY_MODE                   --还款方式 --其他-承兑人到期付款
         ,'01'                                        AS LOAN_FRM                    --贷款形式 D0008
         ,NULL                                        AS RCMB_LOAN_FLG               --重组贷款标识
         ,NULL                                        AS ADJ_BAD_FLG                 --下调为不良标志
         ,NULL                                        AS ALDY_RCMB_FLG               --曾重组标志
         ,NULL                                        AS CTON_PRD_LOAN_FLG           --缩期贷款标志
         ,NULL                                        AS CASH_TRF_FLG                --现转标志
         ,NULL                                        AS FST_LOAN_FLG                --首贷户贷款标志
         ,NULL                                        AS FIRST_LOAN_FLG              --首次贷款标志
         ,CASE WHEN NVL(TRIM(B.GREEN_CRDT_CLS_NEW),'-') NOT IN ('-','999') AND B.STD_PROD_ID NOT IN ('602030100001','602030100002')
               THEN 'Y'
               ELSE 'N'
           END                                        AS PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志  MOD BY YJY 20250604 --MOD BY YJY 20250819
         ,CASE --WHEN SUBSTR(/*B.GREEN_CRDT_CLS_CD*/ B.GREEN_CRDT_CLS_NEW,1,1) IN ('A','B','C','D','E','F')
               WHEN NVL(TRIM(B.GREEN_CRDT_CLS_NEW),'-') NOT IN ('-','999') --MOD BY YJY 20250604 MOD BY YJY 20250819 从借据表取绿色信贷分类_新版代码
                AND B.STD_PROD_ID NOT IN ('602030100001','602030100002')
               THEN 'Y'
               ELSE 'N'
           END                                        AS CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
         ,NULL                                        AS CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
         ,NULL                                        AS LOAN_FINC_SPT_MODE          --贷款财政扶持方式
         ,NULL                                        AS ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
         ,NULL                                        AS RATE_RE_PRC_DT              --利率重新定价日期
         ,NULL                                        AS RATE_FLT_FREQ               --利率浮动频率
         ,NULL                                        AS RATE_TYP                    --利率类型
         ,NULL                                        AS AST_SCRTZ_PROD_ID           --资产证券化产品编号
         ,A.DISCNT_INT_RAT                            AS EXEC_RATE                   --执行利率
         ,NULL                                        AS BASE_RATE                   --基准利率
         ,NULL                                        AS CNTR_GUA_LOAN_FLG           --反担保贷款标志
         ,NULL                                        AS RATE_FLT_VAL                --利率浮动值
         ,NULL                                        AS PRC_BASE_TYP                --定价基准类型
         ,'1'                                         AS TOT_PRD_NUM                 --总期数
         ,'1'                                         AS CURR_PRD                    --当前期数
         ,0                                           AS CUM_DEBT_PRD_NUM            --累计欠款期数
         ,0                                           AS CNU_DEBT_PRD_NUM            --连续欠款期数
         ,0                                           AS EXTN_CNT                    --展期次数
         ,CASE WHEN B.MONEY_USE_TYPE_CD = '2' THEN '02'
               ELSE NVL(TF.TAR_VALUE_CODE,'01')
           END                                        AS DSBR_MODE                   --放款方式
         ,TC.TAR_VALUE_CODE                           AS INT_CALC_MODE               --计息方式 CD1386-->D0061
         /*,NULL                                        AS MRGN_PCT                    --保证金比例
         ,NULL                                        AS MRGN_CUR                    --保证金币种
         ,NULL                                        AS MRGN                        --保证金
         ,NULL                                        AS MRGN_ACC                    --保证金账号*/
         --MOD BY LIP 20251104 调整贴现的保证金相关字段取数口径
         ,H.MARGIN_RATIO                              AS MRGN_PCT                    --保证金比例
         ,CASE WHEN H.MARGIN_CURR_CD IS NULL OR H.MARGIN_CURR_CD = '-' THEN A.CURR_CD
               ELSE H.MARGIN_CURR_CD
           END                                        AS MRGN_CUR                    --保证金币种
         ,H.MARGIN_AMT                                AS MRGN                        --保证金
         ,CASE WHEN TRIM(REPLACE(B.MARGIN_ACCT_NUM,'/','')) IS NOT NULL THEN TRIM(B.MARGIN_ACCT_NUM)
               WHEN TRIM(H.MARGIN_ACCT_NUM) IS NOT NULL THEN TRIM(H.MARGIN_ACCT_NUM)
               ELSE TRIM(TTD.GRTEAC)
           END                                        AS MRGN_ACC                    --保证金账号
         ,A.CUST_MGR_ID                               AS LOAN_OFR_NO                 --信贷员工号
         ,A.INT_AMT                                   AS ACCRD_INT                   --应计利息
         ,NULL                                        AS PRO_IMPT                    --减值准备
         ,NULL                                        AS COM_PRO                     --一般准备
         ,NULL                                        AS SPCL_PRO                    --专项准备
         ,NULL                                        AS ESP_PRO                     --特别准备
         ,NULL                                        AS SPCL_LOAN_FLG               --专项贷款标志
         ,NULL                                        AS ORIG_RCPT_NO                --原借据号
         ,NULL                                        AS FND_PCT                     --出资比例
         ,COALESCE(TRIM(A.DSCNT_PROPS_ACCT_NUM),TRIM(A.DISCNT_APPLIT_ACCT_NUM),TRIM(B.STL_ACCT_NUM))
                                                      AS ETR_ACC                     --入账账号
         ,COALESCE(TRIM(A.DSCNT_PROPS_NAME),E.CUST_NAME,TRIM(B.RECVBL_ACCT_NAME))
                                                      AS ETR_ACC_NM                  --入账账号户名
         --MOD BY LIP 20231103 部分转贴现申请人行号登记的是会员机构号
         ,COALESCE(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(MEMA.ORG_CN_FNAME),TRIM(B.RECVBL_BANK_NAME))
                                                      AS LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
         --银票取出票人账号，商票取贴现申请人的账号
         ,CASE WHEN A.BILL_KIND_CD = 'AC01' 
         THEN TRIM(A.DRAWER_ACCT_NUM)--030101 银行承兑汇票贴现
               WHEN A.BILL_KIND_CD = 'AC02'
               THEN COALESCE(TRIM(A.DSCNT_PROPS_ACCT_NUM),TRIM(A.DISCNT_APPLIT_ACCT_NUM),TRIM(B.STL_ACCT_NUM))--030102 商业承兑汇票贴现
           END                                        AS REPY_ACC                    --还款账号
         ,CASE WHEN A.BILL_KIND_CD = 'AC01' 
         THEN TRIM(A.DRAWER_OPEN_BANK_NAME)--030101 银行承兑汇票贴现
               WHEN A.BILL_KIND_CD = 'AC02'
               --THEN NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(B.RECVBL_BANK_NAME))--030102 商业承兑汇票贴现
               THEN COALESCE(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(MEMA.ORG_CN_FNAME),TRIM(B.RECVBL_BANK_NAME))--030102 商业承兑汇票贴现 --MOD BY LIP 20250911
           END                                        AS LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD')
                AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN 'C01'
               ELSE TD.TAR_VALUE_CODE
           END                                        AS RCPT_STAT                   --借据状态 CD1258-->D0007
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD')
                AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN '02' --02 销户
               ELSE '01' --01 正常
           END                                        AS ACC_STAT                    --账户状态 Z0008
         ,CASE WHEN H.CIRCL_FLG = '1' THEN 'Y'
               ELSE 'N'
           END                                        AS REV_LOAN_FLG                --循环贷贷款标志
         ,NULL                                        AS REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
         ,NULL                                        AS BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
         ,CASE WHEN E.DOM_OVERS_FLG IN ('1','@1') THEN 'Y'
               WHEN E.DOM_OVERS_FLG = '0' THEN 'N' --MODIFY BY MW 20221103 1:境内 0：境外
               ELSE 'Y'
           END                                        AS BIO_LOAN_FLG                 --境内外标志
         ,'800926'                                    AS DEPT_LINE                   --部门条线--/*公司银行总部*/
         ,'票据贴现'                                  AS DATA_SRC                    --数据来源
         ,H.LMT_CONT_ID                               AS LMT_CONT_ID                 --额度合同编号
         ,B.REPAY_WAY_CD                              AS GXH_PAY_TYPE                --还款方式
         ,TO_CHAR(C.ASSET_TRAN_DT,'YYYYMMDD')         AS ASSET_TRAN_DT               --资产转让日期
         ,CASE WHEN B.OVERS_LOAN_FLG = '1' THEN 'Y'
               WHEN B.OVERS_LOAN_FLG = '0' THEN 'N'
               ELSE 'Y'
           END                                        AS LOAN_DIR_BIO_FLG            --贷款投向境内外标识
         ,CASE WHEN B.REFAC_LOAN_STATUS_CD = '1' THEN 'Y'
               ELSE 'N'
           END                                        AS REFAC_FLG                   --支小再贷款标识
         ,A.ACTL_AMT                                  AS BILL_ACT_AMT                --贴现、转贴现实付金额
         ,NULL                                        AS LOAN_MODAL_CD               --贷款形态代码
         ,B.OPER_ORG_ID                               AS OPER_ORG_ID                 --经办机构编号 add by hulj 20221123
         ,B.OPER_TELLER_ID                            AS OPER_TELLER_ID              --经办柜员编号 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            AS LOAN_ACT_FIRST_DT           --本行首贷日期 add by hulj 20221123
         ,NULL                                        AS RENEW_EXP_DAY               --展期到期日期 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            AS FIR_LON_DT                  --征信首贷日期 add by hulj 20221123
         ,T18.CLERK_ID                                AS LOAN_MGR_ID                 --借据主办客户经理号 add by hulj 20221123
         ,B.RGST_TELLER_ID                            AS LOAN_TELLER_ID              --借据主办柜员号 add by hulj 20221123
         ,NVL(T19.TELLER_NAME,T18.CLERK_NAME)         AS LOAN_MGR_NAME               --借据主办客户经理名称 add by hulj 20221123
         ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID)    AS LOAN_MGR_BELONG_ORG_ID      --借据主办客户经理所属机构 add by hulj 20221123
         ,A.CUST_ID                                   AS DISCNT_CUST_ID                      --直贴人客户编号
         ,NULL                                        AS HOLD_DAYS                   --持票天数
         --MOD BY LIP 20230706 贴现借据核心不登记
         ,B.DUBIL_AMT                                 AS DISTR_AMT                   --放款金额
         ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')              AS DISTR_DT                    --放款日期
         ,CASE WHEN (B.PAYOFF_DT >= V_MONTH_START_DATE
                 OR B.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                 OR NVL(A.CURRT_BAL,0) >0)
               THEN 'Y'
               ELSE 'N'
           END                                        AS EAST_FLG                   --EAST口径标识
         ,NULL                                        AS CTR_NT_ID                  --成交单编号
         ,NULL                                        AS RECVBL_PNLT                --应收罚息
         ,NULL                                        AS COLL_PNLT                  --催收罚息
         ,NULL                                        AS RECVBL_COMP_INT            --应收复息
         ,NULL                                        AS RECVBL_INT_SUB             --应收贴息
         ,NULL                                        AS RECVBL_FINE                --应收罚息
         ,NULL                                        AS RECVBL_OVER_INT            --应收欠息
         ,NULL                                        AS COLL_OVER_INT              --催收欠息
         ,H.TENOR                                     AS TENOR                      --剩余期限
         ,NULL                                        AS LOAN_USEAGE_SUB_CL         --贷款用途细类
         ,NULL                                        AS CUST_CHAR                  --客户性质
         ,B.OUT_ACCT_FLOW_NUM                         AS OUT_ACCT_FLOW_NUM          --出账流水号
         ,B.CUST_ID                                   AS ICMS_CUST_ID               --信贷客户编号
         ,A.HXB_ACPT_FLG                              AS HXB_ACPT_FLG               --我行承兑标识
         ,A.BILL_SUB_INTRV_ID                         AS BILL_SUB_INTRV_ID          --子票据区间编号
         ,TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')             AS PAYOFF_DT                  --结清日期       --ADD BY YJY 20241022
         ,NVL(B.SUIT_FEE_BAL,0)                       AS SUIT_FEE_BAL               --诉讼费余额     --ADD BY YJY 20241217
         ,A.BILL_NUM                                  AS BILL_NUM                   --票据编码        --ADD BY YJY 20250410
         ,B.GREEN_CRDT_CLS_CD                         AS GREEN_CRDT_CLS_CD          --绿色信贷分类_旧版代码 --ADD BY LIP 20251013
         ,B.GREEN_CRDT_CLS_NEW                        AS GREEN_CRDT_CLS_NEW         --绿色信贷分类_新版代码 --ADD BY YJY 20250508
         ,CASE WHEN (B.PAYOFF_DT >= V_YEAR_START_DATE
                 OR B.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
                 OR NVL(A.CURRT_BAL,0) >0)
               THEN 'Y'
               ELSE 'N'
           END                                        AS YBT_FLG                     --一表通口径标识 --ADD BY PSF 20250916
       ,NULL                                        AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
       ,NULL                                        AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
       ,NULL                                        AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
       ,A.ACTL_AMT                                  AS ACTL_AMT                    --实付金额 ADD BY YJY 20260324
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
     AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO C  --对公贷款账户信息
      ON C.DUBIL_NUM = B.DUBIL_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO H --对公贷款合同信息
      ON H.CONT_ID = B.CONT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO M --标准产品信息表
      ON M.PROD_ID = B.STD_PROD_ID --MOD BY YJY 20250213
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
      ON F.PARTY_ID = A.CUST_ID
     AND F.SRC_SYS_CD = 'CRSS'
     AND F.PHYS_ADDR_TYPE_CD = /*'001001'*/ '06' --办公营业地址  MOD BY YJY 20260119
     AND TRIM(F.DIST_CD) NOT IN ('1000','999999','000000')
     AND F.ID_MARK <> 'D'
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H T3 --贷款出账申请历史
      ON T3.DUBIL_ID = B.DUBIL_ID
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
      ON O.V_TRADE_NO = A.BILL_ID               --MODIFY BY MW 20220522  关联字段改为BILL_ID
     AND O.V_BUSINESSTYPE = B.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.DISCNT_APPLIT_BANK_NO)
     AND TTA.RANK = 1
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM MEMA --票交所会员 ADD BY LIP 20231103 部分数据的行号登记的是会员机构号
      ON MEMA.MEM_ORG_CD = TRIM(A.DISCNT_APPLIT_BANK_NO)
     AND MEMA.ID_MARK <> 'D'
    LEFT JOIN RRP_MDL.CODE_MAP TTA  --码值映射表(贷款类型)
      ON TTA.SRC_VALUE_CODE = B.STD_PROD_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级形态转码
      ON TB.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --五级形态转码
      ON TC.SRC_VALUE_CODE = B.COL_INT_TYPE_CD
     AND TC.SRC_CLASS_CODE = 'CD1386'
     AND TC.TAR_CLASS_CODE = 'D0061'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TD --借据状态转码
      ON TD.SRC_VALUE_CODE = B.DUBIL_STATUS_CD
     AND TD.SRC_CLASS_CODE = 'CD2554' --MOD BY YJY 20250313  码值替换 CD2651 --> CD2554
     AND TD.TAR_CLASS_CODE = 'D0007'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TF --放款方式转码 CD1372-->D0104
      ON TF.SRC_VALUE_CODE = T3.DISTR_MODE_PAY_CD
     AND TF.SRC_CLASS_CODE = 'CD1372'
     AND TF.TAR_CLASS_CODE = 'D0104'
     AND TF.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT T.*
                      ,ROW_NUMBER() OVER(PARTITION BY T.TELLER_ID ORDER BY T.DIMISSION_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CLERK_INFO T   --行员信息表
                WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND T.TELLER_ID IS NOT NULL) T18
      ON T18.TELLER_ID = B.RGST_TELLER_ID
     AND T18.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T19  --柜员信息
      ON T19.TELLER_ID = B.RGST_TELLER_ID
     AND T19.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN DEPOSIT_APPLY_INFO TTD --保证金追加流水表 --ADD BY LIP 20251104 根据信贷反馈，当合同的保证金账号为空时，取追加表的账号
      ON TTD.CONTRACTNO = B.CONT_ID
     AND TTD.RN = 1
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03' --03 记账完成
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--对公贷款买断式转贴现部分';
  V_STARTTIME := SYSDATE;
  INSERT/*+APPEND PARALLEL*/ INTO M_LOAN_IN_DUBILL_INFO_TMP
    (DATA_DT                             --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                             --借据编号
    ,CONT_ID                             --合同编号
    ,BILL_NO                             --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                             --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                             --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                 --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                             --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                     --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                     --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                       --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                         --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                         --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                             --逾期类型
    ,LOAN_USEAGE                         --贷款用途
    ,LVL5_CL                             --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                       --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                   --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                     --房地产贷款标志
    ,IALL_LOAN_FLG                       --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                 --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG               --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG             --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                       --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
    ,REPY_MODE                           --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                       --重组贷款标识
    ,ADJ_BAD_FLG                         --下调为不良标志
    ,ALDY_RCMM_FLG                       --曾重组标志
    ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                       --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
    ,EXEC_RATE                           --执行利率
    ,BASE_RATE                           --基准利率
    ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                         --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                           --放款方式
    ,INT_CALC_MODE                       --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                         --信贷员工号
    ,ACCRD_INT                           --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                             --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                             --特别准备
    ,SPCL_LOAN_FLG                       --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                             --出资比例
    ,ETR_ACC                             --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                           --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                        --境内外标志
    ,DEPT_LINE                           --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,ASSET_TRAN_DT                       --资产转让日期
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 ADD BY HULJ 20221123
    ,OPER_TELLER_ID                      --经办柜员编号 ADD BY HULJ 20221123
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 ADD BY HULJ 20221123
    ,RENEW_EXP_DAY                       --展期到期日期 ADD BY HULJ 20221123
    ,FIR_LON_DT                          --征信首贷日期 ADD BY HULJ 20221123
    ,LOAN_MGR_ID                         --借据主办客户经理号 ADD BY HULJ 20221123
    ,LOAN_TELLER_ID                      --借据主办柜员号 ADD BY HULJ 20221123
    ,LOAN_MGR_NAME                       --借据主办客户经理名称 ADD BY HULJ 20221123
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构 ADD BY HULJ 20221123
    ,DISCNT_CUST_ID                      --直贴人客户编号
    ,SYS_IN_FLG                          --系统内标志： 1系统外 0系统内
    ,HOLD_DAYS                           --持票日期
    ,DISTR_AMT                           --放款金额
    ,DISTR_DT                            --放款日期
    ,EAST_FLG                            --EAST口径标识
    ,CTR_NT_ID                           --成交单编号
    ,RECVBL_PNLT                         --应收罚息
    ,COLL_PNLT                           --催收罚息
    ,RECVBL_COMP_INT                     --应收复息
    ,RECVBL_INT_SUB                      --应收贴息
    ,RECVBL_FINE                         --应收罚息
    ,RECVBL_OVER_INT                     --应收欠息
    ,COLL_OVER_INT                       --催收欠息
    ,LOAN_USEAGE_SUB_CL                  --贷款用途细类
    ,CUST_CHAR                           --客户性质
    ,OUT_ACCT_FLOW_NUM                   --出账流水号
    ,ICMS_CUST_ID                        --信贷客户编号
    ,HXB_ACPT_FLG                        --我行承兑标识
    ,BILL_SUB_INTRV_ID                   --子票据区间编号
    ,PAYOFF_DT                           --结清日期       --ADD BY YJY 20241022
    ,SUIT_FEE_BAL                        --诉讼费余额     --ADD BY YJY 20241217
    ,BILL_NUM                            --票据编码       --ADD BY YJY 20250410
    ,GREEN_CRDT_CLS_NEW                  --绿色信贷分类_新版代码 --ADD BY YJY 20250508
    ,YBT_FLG                             --一表通口径标识 --ADD BY PSF 20250916
    ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    ,ACTL_AMT                            --实付金额 ADD BY YJY 20260324
    )
    WITH DEPOSIT_APPLY_INFO AS ( --ADD BY LIP 20251104 
  SELECT /*+MATERIALIZE*/TA.*,ROW_NUMBER() OVER(PARTITION BY TA.CONTRACTNO ORDER BY TA.EXCHANGEDATE,TA.PUTOUTNO) RN
    FROM RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO TA --保证金流水追加表
   WHERE TA.APPROVESTATUS = 'Finished'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')                AS DATA_DT                     --数据日期
         ,A.LP_ID                                     AS LGL_REP_ID                  --法人编号
         ,B.DUBIL_ID                                  AS ACC_ID                      --账户编号
         ,B.DUBIL_ID                                  AS RCPT_ID                     --借据编号
         ,B.CONT_ID                                   AS CONT_ID                     --合同编号
         ,A.BILL_ID                                   AS BILL_NO                     --票据号码 20220420改为票据唯一ID
         ,NULL                                        AS COOP_AGRT_ID                --合作协议编号
         ,A.CNTPTY_ID                                 AS CUST_ID                     --客户编号 取交易对手的客户编号
         ,A.ACCT_INSTIT_ID                            AS ORG_ID                      --机构编号
         ,A.SUBJ_ID                                   AS SUBJ_ID                     --科目编号
         ,B.STD_PROD_ID                               AS LOAN_STD_PROD_ID            --贷款标准产品编号
         ,M.PROD_NAME                                 AS LOAN_STD_PROD_NM            --贷款标准产品名称
         ,B.STD_PROD_ID                               AS LOAN_PROD_ID                --贷款产品编号
         ,M.PROD_NAME                                 AS LOAN_PROD_NM                --贷款产品名称
         ,NVL(TG.TAR_VALUE_CODE,B.STD_PROD_ID)        AS LOAN_BIZ_TYP                --贷款业务类型 --买断式转贴现
         ,A.CURR_CD                                   AS CUR                         --币种
         ,A.FAC_VAL_AMT                               AS LOAN_AMT                    --借款金额
         ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD')
                AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                AND J.PAYOFF_FLG = '0'
               THEN ROUND((NVL(A.CURRT_BAL,0)),2)
               WHEN NVL(A.CURRT_BAL,0) > 0
                AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN ROUND((NVL(A.CURRT_BAL,0)),2)
               ELSE 0  --MODIFY BY HYF 公允价值变动四舍五入取小数点后二位
           END                                        AS LOAN_BAL                    --贷款余额
         ,CASE WHEN B.DISTR_DT < TO_DATE(V_P_DATE,'YYYYMMDD')
                AND B.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                AND J.PAYOFF_FLG = '0'
               THEN NVL(A.INT_ADJ_BAL,0)
               WHEN NVL(A.CURRT_BAL,0) > 0 AND B.PAYOFF_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN NVL(A.INT_ADJ_BAL,0)
               ELSE 0  --MODIFY BY HYF 公允价值变动四舍五入取小数点后二位
           END                                        AS INT_ADJ                     --利息调整
         ,ROUND(NVL(O.N_PV_VARIATION,0),2)            AS FAIR_VAL_CHG                --公允价值变动
         ,NULL                                        AS OVD_PRIN_BAL                --逾期本金余额
         ,NULL                                        AS IN_INT_OVD_BAL              --表内欠息余额
         ,NULL                                        AS OUT_INT_OVD_BAL             --表外欠息余额
         ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')              AS LOAN_ACT_DSTR_DT            --贷款实际发放日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                AS LOAN_ORIG_EXP_DT            --贷款原始到期日期
         ,TO_CHAR(A.ACTL_EXP_DT,'YYYYMMDD')           AS LOAN_ACT_EXP_DT             --贷款实际到期日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        AS ACT_END_DT                  --实际终止日期
         ,NULL                                        AS LAST_REPY_DT                --上次还款日期
         ,NULL                                        AS LAST_REPY_AMT               --上次还款金额
         ,CASE WHEN A.SYS_IN_FLG= '1'
               THEN TO_CHAR(A.BUS_DT,'YYYYMMDD')
               ELSE TO_CHAR(A.DISCNT_DT,'YYYYMMDD')
           END                                        AS VAL_DT                      --起息日期20221206 MODIFY
         ,TO_CHAR(A.APPL_DT,'YYYYMMDD')               AS OPEN_ACC_DT                 --开户日期
         ,CASE WHEN TO_CHAR(B.PAYOFF_DT,'YYYYMMDD') IN ('00010101')
               THEN NULL
               ELSE TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')
           END                                        AS CNL_ACC_DT                  --销户日期
         ,NULL                                        AS PRIN_OVD_DT                 --本金逾期日期
         ,NULL                                        AS INT_OVD_DT                  --利息逾期日期
         ,NULL                                        AS OVD_DAYS                    --逾期天数
         ,CASE WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
               WHEN C.PRIC_OVDUE_DAYS > 0 AND C.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
               WHEN C.PRIC_OVDUE_DAYS = 0 AND C.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
               ELSE NULL
           END                                        AS OVD_TYP                  --逾期类型
         ,NVL(TRIM(H.LOAN_USAGE_DESCB),'上海票据交易所系统参与者间开展的票据交易') LOAN_USEAGE --贷款用途
         ,TB.TAR_VALUE_CODE                           AS LVL5_CL                     --五级分类
         ,B.GUAR_WAY_CD                               AS GUA_MODE                    --担保方式
         ,CASE WHEN E.RG_CD = '810000' THEN 'HKG'
               WHEN E.RG_CD = '820000' THEN 'MAC'
               WHEN E.RG_CD = '710000' THEN 'TWN'
               WHEN NVL(TRIM(E.INVTOR_CTY_CD), '1111') NOT IN ('CHN', 'XXX', '1111') THEN TRIM(E.INVTOR_CTY_CD)
               WHEN TRIM(E.RG_CD) NOT IN ('1000','999999','000000') THEN TRIM(E.RG_CD)
               WHEN TRIM(F.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(F.DIST_CD)
               WHEN TRIM(TTA.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(TTA.DIST_CD)
               WHEN TRIM(TTB.DIST_CD) NOT IN ('1000','999999','000000') THEN TRIM(TTB.DIST_CD)
           END                                        AS LOAN_DIR_RGN                --贷款投向地区
         ,CASE WHEN B.DIR_INDUS_CD= '-' THEN 'Z'
               ELSE NVL(B.DIR_INDUS_CD,'Z')
           END                                        AS LOAN_DIR_IDY                --贷款投向行业
         ,NULL                                        AS SYN_LOAN_FLG                --银团贷款标志
         ,NULL                                        AS PROJ_LOAN_FLG               --项目贷款标志
         ,NULL                                        AS IDY_STRU_ADJ_TYP            --产业结构调整类型
         ,NULL                                        AS IDY_TRNST_UPG_FLG           --工业转型升级标志
         ,NULL                                        AS STRTG_EMER_IDY_TYP          --战略新兴产业类型
         ,'N'                                         AS BANK_TAX_COOP_LOAN_FLG   --银税合作贷款标志
         ,CASE WHEN H.AGCLT_FLG= '1' THEN 'Y' ELSE 'N'
           END                                        AS AGR_REL_LOAN_FLG            --涉农贷款标志
         ,NULL                                        AS RL_EST_LOAN_FLG             --房地产贷款标志
         ,NULL                                        AS IALL_LOAN_FLG               --投贷联动贷款标志
         ,NULL                                        AS OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
         ,NULL                                        AS GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
         ,NULL                                        AS ENT_GUA_LOAN_TYP            --创业担保贷款类型
         ,NULL                                        AS CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
         ,NULL                                        AS LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
         ,NULL                                        AS LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
         ,NULL                                        AS FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
         ,NULL                                        AS POV_ALLE_REC_FLG            --建档立卡贫困人口贷款标志
         ,NULL                                        AS LOAN_HDL_CHAN               --贷款办理渠道
         ,'N'                                         AS NET_LOAN_FLG                --互联网贷款标志
         ,'0'                                         AS NET_LOAN_PROD_TYP            --网贷产品类别
         ,NULL                                        AS CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
         ,'9914'                                      AS REPY_MODE                   --还款方式 --其他-承兑人到期付款
         ,'01'                                        AS LOAN_FRM                    --贷款形式 D0008
         ,NULL                                        AS RCMB_LOAN_FLG               --重组贷款标识
         ,NULL                                        AS ADJ_BAD_FLG                 --下调为不良标志
         ,NULL                                        AS ALDY_RCMB_FLG               --曾重组标志
         ,NULL                                        AS CTON_PRD_LOAN_FLG           --缩期贷款标志
         ,NULL                                        AS CASH_TRF_FLG                --现转标志
         ,NULL                                        AS FST_LOAN_FLG                --首贷户贷款标志
         ,NULL                                        AS FIRST_LOAN_FLG              --首次贷款标志
         --,NULL                                        AS PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
         ,CASE WHEN NVL(TRIM(B.GREEN_CRDT_CLS_NEW),'-') NOT IN ('-','999')
               THEN 'Y'
               ELSE 'N'
           END                                        AS PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志 MOD BY YJY 20250819
         ,'N'                                         AS CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志 --监管报送中的表内借据没统计这部分
         ,NULL                                        AS CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
         ,NULL                                        AS LOAN_FINC_SPT_MODE          --贷款财政扶持方式
         ,NULL                                        AS ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
         ,NULL                                        AS RATE_RE_PRC_DT              --利率重新定价日期
         ,NULL                                        AS RATE_FLT_FREQ               --利率浮动频率
         ,NULL                                        AS RATE_TYP                    --利率类型
         ,NULL                                        AS AST_SCRTZ_PROD_ID           --资产证券化产品编号
         ,A.DISCNT_INT_RAT                            AS EXEC_RATE                   --执行利率
         ,NULL                                        AS BASE_RATE                   --基准利率
         ,NULL                                        AS CNTR_GUA_LOAN_FLG           --反担保贷款标志
         ,NULL                                        AS RATE_FLT_VAL                --利率浮动值
         ,NULL                                        AS PRC_BASE_TYP                --定价基准类型
         ,'1'                                         AS TOT_PRD_NUM                 --总期数
         ,'1'                                         AS CURR_PRD                    --当前期数
         ,0                                           AS CUM_DEBT_PRD_NUM            --累计欠款期数
         ,0                                           AS CNU_DEBT_PRD_NUM            --连续欠款期数
         ,0                                           AS EXTN_CNT                    --展期次数
         ,CASE WHEN B.MONEY_USE_TYPE_CD = '2'
               THEN '02'
               ELSE NVL(TF.TAR_VALUE_CODE,'01')
           END                                        AS DSBR_MODE                   --放款方式
         ,TC.TAR_VALUE_CODE                           AS INT_CALC_MODE               --计息方式 CD1386-->D0061
         /*,NULL                                        AS MRGN_PCT                    --保证金比例
         ,NULL                                        AS MRGN_CUR                    --保证金币种
         ,NULL                                        AS MRGN                        --保证金
         ,NULL                                        AS MRGN_ACC                    --保证金账号*/
         --MOD BY LIP 20251104 调整贴现的保证金相关字段取数口径
         ,H.MARGIN_RATIO                              AS MRGN_PCT                    --保证金比例
         ,CASE WHEN H.MARGIN_CURR_CD IS NULL OR H.MARGIN_CURR_CD = '-' THEN A.CURR_CD
               ELSE H.MARGIN_CURR_CD
           END                                        AS MRGN_CUR                    --保证金币种
         ,H.MARGIN_AMT                                AS MRGN                        --保证金
         ,CASE WHEN TRIM(REPLACE(B.MARGIN_ACCT_NUM,'/','')) IS NOT NULL THEN TRIM(B.MARGIN_ACCT_NUM)
               WHEN TRIM(H.MARGIN_ACCT_NUM) IS NOT NULL THEN TRIM(H.MARGIN_ACCT_NUM)
               ELSE TRIM(TTD.GRTEAC)
           END                                        AS MRGN_ACC                    --保证金账号
         ,A.CUST_MGR_ID                               AS LOAN_OFR_NO                 --信贷员工号
         ,A.INT_AMT                                   AS ACCRD_INT                   --应计利息
         ,NULL                                        AS PRO_IMPT                    --减值准备
         ,NULL                                        AS COM_PRO                     --一般准备
         ,NULL                                        AS SPCL_PRO                    --专项准备
         ,NULL                                        AS ESP_PRO                     --特别准备
         ,NULL                                        AS SPCL_LOAN_FLG               --专项贷款标志
         ,NULL                                        AS ORIG_RCPT_NO                --原借据号
         ,NULL                                        AS FND_PCT                     --出资比例
         ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD) AS ETR_ACC                 --入账账号 --参考答疑口径二期740、704调整
         ,A.CNTPTY_NAME                               AS ETR_ACC_NM                  --入账账号户名
         ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME)
                                                      AS LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
         ,COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD) AS REPY_ACC                --还款账号
         ,COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME)
                                                      AS LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD')
                AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN 'C01'
               ELSE TD.TAR_VALUE_CODE
           END                                        AS RCPT_STAT                   --借据状态 CD1258-->D0007
         ,CASE WHEN B.PAYOFF_DT NOT IN TO_DATE('00010101','YYYYMMDD')
                AND B.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               THEN '02' --02 销户
               ELSE '01' --01 正常
           END                                        AS ACC_STAT                    --账户状态
         ,CASE WHEN H.CIRCL_FLG = '1' THEN 'Y'
               ELSE 'N'
           END                                        AS REV_LOAN_FLG                --循环贷贷款标志
         ,NULL                                        AS REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
         ,NULL                                        AS BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
         ,CASE WHEN E.DOM_OVERS_FLG IN ('1','@1') THEN 'Y'
               WHEN E.DOM_OVERS_FLG = '0' THEN 'N' --MODIFY BY MW 20221103 1:境内 0：境外
               ELSE 'Y'
           END                                        AS BIO_LOAN_FLG                --境内外标志
         ,NULL                                        AS DEPT_LINE                   --部门条线--票据业务事业部
         ,'票据转贴现'                                AS DATA_SRC                    --数据来源
         ,H.LMT_CONT_ID                               AS LMT_CONT_ID                 --额度合同编号
         ,B.REPAY_WAY_CD                              AS GXH_PAY_TYPE                --还款方式
         ,TO_CHAR(C.ASSET_TRAN_DT,'YYYYMMDD')         AS ASSET_TRAN_DT               --资产转让日期
         ,CASE WHEN B.OVERS_LOAN_FLG = '1' THEN 'Y'
               WHEN B.OVERS_LOAN_FLG = '0' THEN 'N'
               ELSE 'Y'
           END                                        AS LOAN_DIR_BIO_FLG            --贷款投向境内外标识
         ,CASE WHEN B.REFAC_LOAN_STATUS_CD = '1' THEN 'Y'
               ELSE 'N'
           END                                        AS REFAC_FLG                   --支小再贷款标识
         ,A.STL_AMT                                   AS BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
         ,NULL                                        AS LOAN_MODAL_CD               --贷款形态代码
         ,B.OPER_ORG_ID                               AS OPER_ORG_ID                 --经办机构编号 add by hulj 20221123
         ,B.OPER_TELLER_ID                            AS OPER_TELLER_ID              --经办柜员编号 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            AS LOAN_ACT_FIRST_DT           --本行首贷日期 add by hulj 20221123
         ,NULL                                        AS RENEW_EXP_DAY               --展期到期日期 add by hulj 20221123
         ,TO_CHAR(E.FIR_LON_DT,'YYYYMMDD')            AS FIR_LON_DT                  --征信首贷日期 add by hulj 20221123
         ,T18.CLERK_ID                                AS LOAN_MGR_ID                 --借据主办客户经理号 add by hulj 20221123
         ,B.RGST_TELLER_ID                            AS LOAN_TELLER_ID              --借据主办柜员号 add by hulj 20221123
         ,NVL(T19.TELLER_NAME, T18.CLERK_NAME)        AS LOAN_MGR_NAME               --借据主办客户经理名称 add by hulj 20221123
         ,NVL(T19.BELONG_ORG_ID,T18.BELONG_ORG_ID)    AS LOAN_MGR_BELONG_ORG_ID      --借据主办客户经理所属机构 add by hulj 20221123
         ,NVL(T4.CUST_ID,DECODE(A.DISCNT_PS_NAME,S.CUST_NAME,S.CUST_ID,A.DISCNT_PS_NAME))
                                                      AS DISCNT_CUST_ID              --直贴人客户编号
         ,A.SYS_IN_FLG                                AS SYS_IN_FLG                  --系统外标志： 1系统外 0系统内
         ,A.HOLD_DAYS                                 AS HOLD_DAYS                   --持票日期
         --MOD BY LIP 20230706 转贴现借据核心不登记
         ,B.DUBIL_AMT                                 AS DISTR_AMT                   --放款金额
         ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')              AS DISTR_DT                    --放款日期
         ,CASE WHEN (B.PAYOFF_DT >= V_MONTH_START_DATE OR B.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
               THEN 'Y'
               ELSE 'N'
           END                                        AS EAST_FLG                    --EAST口径标识
         ,A.CTR_NT_ID                                 AS CTR_NT_ID                   --成交单编号
         ,NULL                                        AS RECVBL_PNLT                 --应收罚息
         ,NULL                                        AS COLL_PNLT                   --催收罚息
         ,NULL                                        AS RECVBL_COMP_INT             --应收复息
         ,NULL                                        AS RECVBL_INT_SUB              --应收贴息
         ,NULL                                        AS RECVBL_FINE                 --应收罚息
         ,NULL                                        AS RECVBL_OVER_INT             --应收欠息
         ,NULL                                        AS COLL_OVER_INT               --催收欠息
         ,NULL                                        AS LOAN_USEAGE_SUB_CL          --贷款用途细类
         ,NULL                                        AS CUST_CHAR                   --客户性质
         ,B.OUT_ACCT_FLOW_NUM                         AS OUT_ACCT_FLOW_NUM           --出账流水号
         ,B.CUST_ID                                   AS ICMS_CUST_ID                --信贷客户编号
         ,A.HXB_ACPT_FLG                              AS HXB_ACPT_FLG                --我行承兑标识
         ,A.BILL_SUB_INTRV_ID                         AS BILL_SUB_INTRV_ID           --子票据区间编号
         ,TO_CHAR(B.PAYOFF_DT,'YYYYMMDD')             AS PAYOFF_DT                   --结清日期       --ADD BY YJY 20241022
         ,NVL(B.SUIT_FEE_BAL,0)                       AS SUIT_FEE_BAL                --诉讼费余额     --ADD BY YJY 20241217
         ,A.BILL_NUM                                  AS BILL_NUM                    --票据编码       --ADD BY YJY 20250410
         ,B.GREEN_CRDT_CLS_NEW                        AS GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
         ,CASE WHEN (B.PAYOFF_DT >= V_YEAR_START_DATE OR B.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(A.CURRT_BAL,0) >0)
               THEN 'Y'
               ELSE 'N'
           END                                        AS YBT_FLG                     --一表通口径标识--ADD BY PSF 20250916
       ,NULL                                        AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
       ,NULL                                        AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
       ,NULL                                        AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
       ,A.STL_AMT                                   AS ACTL_AMT                    --实付金额 ADD BY YJY 20260324
   FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002') --20220924 MW 修改'204010100001' 银行承兑汇票转贴现 ‘204010100002’ 商业承兑汇票转贴现
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO M --标准产品信息
      ON M.PROD_ID = A.STD_PROD_ID
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO H --对公贷款合同信息
      ON H.CONT_ID = B.CONT_ID
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO C --对公贷款账户信息
      ON C.DUBIL_NUM = B.DUBIL_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO J --票据中心信息
      ON J.BILL_ID = A.BILL_ID
     AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H T3 --贷款出账申请历史
      ON T3.DUBIL_ID = B.DUBIL_ID
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT BILL_NUM
                      ,BILL_SUB_INTRV_ID
                      ,MIN(CUST_ID)   AS CUST_ID
                      ,MIN(CUST_NAME) AS CUST_NAME --对客户号进行去重 20240111
                 FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A --票据贴现信息
                WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态 06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
                  AND A.ENTRY_STATUS_CD = '03'
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY BILL_NUM,BILL_SUB_INTRV_ID) T4
      ON T4.BILL_NUM = A.BILL_NUM
     AND T4.BILL_SUB_INTRV_ID = A.BILL_SUB_INTRV_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = B.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
      ON F.PARTY_ID = B.CUST_ID
     AND F.SRC_SYS_CD = 'CRSS'
     AND F.PHYS_ADDR_TYPE_CD = /*'001001'*/ '06' --办公营业地址 MOD BY YJY 20260119
     AND TRIM(F.DIST_CD) NOT IN ('1000','999999','000000')
     AND F.ID_MARK <> 'D'
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --估值报告表
      ON O.V_TRADE_NO = A.BILL_ID --MODIFY BY MW 20221209 根据源系统口径改为BILL_ID关联
     AND O.V_BUSINESSTYPE = B.STD_PROD_ID
     AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.CNTPTY_BANK_NO)
     AND TTA.ID_MARK <> 'D' 
     AND TTA.RANK = 1
    LEFT JOIN RRP_MDL.O_IML_PTY_CPES_MEM TTB --票交所会员 只有一天数据
      ON TTB.ORG_CN_ABBR = TRIM(A.CNTPTY_NAME)
     AND TTB.ID_MARK <> 'D' 
     AND TTB.RANK = 1
    LEFT JOIN RRP_MDL.CODE_MAP TB --五级形态转码
      ON TB.SRC_VALUE_CODE = B.LOAN_LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --五级形态转码
      ON TC.SRC_VALUE_CODE = B.COL_INT_TYPE_CD
     AND TC.SRC_CLASS_CODE = 'CD1386'
     AND TC.TAR_CLASS_CODE = 'D0061'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TD --借据状态转码
      ON TD.SRC_VALUE_CODE = B.DUBIL_STATUS_CD
     AND TD.SRC_CLASS_CODE = 'CD2554' --MOD BY YJY 20250313  码值替换 CD2651 --> CD2554
     AND TD.TAR_CLASS_CODE = 'D0007'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TF --放款方式转码 CD1372-->D0104
      ON TF.SRC_VALUE_CODE = T3.DISTR_MODE_PAY_CD
     AND TF.SRC_CLASS_CODE = 'CD1372'
     AND TF.TAR_CLASS_CODE = 'D0104'
     AND TF.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TG --业务品种编号转码
      ON TG.SRC_VALUE_CODE = B.STD_PROD_ID
     AND TG.SRC_CLASS_CODE = 'STD0002'
     AND TG.TAR_CLASS_CODE = 'T0001'
     AND TG.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT T.*
                      ,ROW_NUMBER() OVER(PARTITION BY T.TELLER_ID ORDER BY T.DIMISSION_DT DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CLERK_INFO T
                WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND T.TELLER_ID IS NOT NULL) T18
      ON T18.TELLER_ID = B.RGST_TELLER_ID
     AND T18.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_TELLER_INFO T19
      ON T19.TELLER_ID = B.RGST_TELLER_ID
     AND T19.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT MIN(G.CUST_ID) AS CUST_ID
                      ,REPLACE((REPLACE(TRIM(G.CUST_NAME),'（','(')),'）',')') AS CUST_NAME
                 FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息 mod by 调整客户号取值20230803
                WHERE G.CUST_STATUS_CD <> '2'
                  AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY REPLACE((REPLACE(TRIM(G.CUST_NAME),'（','(')),'）',')')) S
      ON S.CUST_NAME = REPLACE((REPLACE(TRIM(A.DISCNT_PS_NAME),'（','(')),'）',')')
    LEFT JOIN DEPOSIT_APPLY_INFO TTD --保证金追加流水表 --ADD BY LIP 20251104 根据信贷反馈，当合同的保证金账号为空时，取追加表的账号
      ON TTD.CONTRACTNO = B.CONT_ID
     AND TTD.RN = 1
   WHERE A.TRAN_DIR_CD = '01'      --MODIFY BY MW 20221207  上游码值变化
     AND A.BUS_TYPE_CD = 'BT01'    -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03'  --筛选记账成功的票据
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY  YJY 20250213 对公联合网贷-微业贷的逻辑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--对公联合网贷-微业贷';
  V_STARTTIME := SYSDATE;
  INSERT/*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ACC_ID                      --账户编号
    ,RCPT_ID                     --借据编号
    ,THIRD_RCPT_ID               --内部借据号  ADD BY YJY 20250521
    ,CONT_ID                     --合同编号
    ,BILL_NO                     --票据号码
    ,COOP_AGRT_ID                --合作协议编号
    ,CUST_ID                     --客户编号
    ,ORG_ID                      --机构编号
    ,SUBJ_ID                     --科目编号
    ,LOAN_STD_PROD_ID            --贷款标准产品编号
    ,LOAN_STD_PROD_NM            --贷款标准产品名称
    ,LOAN_PROD_ID                --贷款产品编号
    ,LOAN_PROD_NM                --贷款产品名称
    ,LOAN_BIZ_TYP                --贷款业务类型
    ,CUR                         --币种
    ,LOAN_AMT                    --借款金额
    ,LOAN_BAL                    --贷款余额
    ,INT_ADJ                     --利息调整
    ,FAIR_VAL_CHG                --公允价值变动
    ,OVD_PRIN_BAL                --逾期本金余额
    ,IN_INT_OVD_BAL              --表内欠息余额
    ,OUT_INT_OVD_BAL             --表外欠息余额
    ,LOAN_ACT_DSTR_DT            --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT            --贷款原始到期日期
    ,LOAN_ACT_EXP_DT             --贷款实际到期日期
    ,ACT_END_DT                  --实际终止日期
    ,LAST_REPY_DT                --上次还款日期
    ,LAST_REPY_AMT               --上次还款金额
    ,VAL_DT                      --起息日期
    ,OPEN_ACC_DT                 --开户日期
    ,CNL_ACC_DT                  --销户日期
    ,PRIN_OVD_DT                 --本金逾期日期
    ,INT_OVD_DT                  --利息逾期日期
    ,OVD_DAYS                    --逾期天数
    ,OVD_TYP                     --逾期类型
    ,LOAN_USEAGE                 --贷款用途
    ,LVL5_CL                     --五级分类
    ,GUA_MODE                    --担保方式
    ,LOAN_DIR_RGN                --贷款投向地区
    ,LOAN_DIR_IDY                --贷款投向行业
    ,SYN_LOAN_FLG                --银团贷款标志
    ,PROJ_LOAN_FLG               --项目贷款标志
    ,IDY_STRU_ADJ_TYP            --产业结构调整类型
    ,IDY_TRNST_UPG_FLG           --工业转型升级标志
    ,STRTG_EMER_IDY_TYP          --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG      --银税合作贷款标志
    ,AGR_REL_LOAN_FLG            --涉农贷款标志
    ,RL_EST_LOAN_FLG             --房地产贷款标志
    ,IALL_LOAN_FLG               --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG         --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL          --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP            --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG       --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG     --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP    --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP  --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG            --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN               --贷款办理渠道
    ,NET_LOAN_FLG                --互联网贷款标志
    ,NET_LOAN_PROD_TYP           --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP           --类信用卡业务透支类型
    ,REPY_MODE                   --还款方式
    ,LOAN_FRM                    --贷款形式
    ,RCMM_LOAN_FLG               --重组贷款标识
    ,ADJ_BAD_FLG                 --下调为不良标志
    ,ALDY_RCMM_FLG               --曾重组标志
    ,CTON_PRD_LOAN_FLG           --缩期贷款标志
    ,CASH_TRF_FLG                --现转标志
    ,FST_LOAN_FLG                --首贷户贷款标志
    ,FIRST_LOAN_FLG              --首次贷款标志
    ,PBOC_GRN_LOAN_FLG           --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE          --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
    ,RATE_RE_PRC_DT              --利率重新定价日期
    ,RATE_FLT_FREQ               --利率浮动频率
    ,RATE_TYP                    --利率类型
    ,AST_SCRTZ_PROD_ID           --资产证券化产品编号
    ,EXEC_RATE                   --执行利率
    ,BASE_RATE                   --基准利率
    ,CNTR_GUA_LOAN_FLG           --反担保贷款标志
    ,RATE_FLT_VAL                --利率浮动值
    ,PRC_BASE_TYP                --定价基准类型
    ,TOT_PRD_NUM                 --总期数
    ,CURR_PRD                    --当前期数
    ,CUM_DEBT_PRD_NUM            --累计欠款期数
    ,CNU_DEBT_PRD_NUM            --连续欠款期数
    ,EXTN_CNT                    --展期次数
    ,DSBR_MODE                   --放款方式
    ,INT_CALC_MODE               --计息方式
    ,MRGN_PCT                    --保证金比例
    ,MRGN_CUR                    --保证金币种
    ,MRGN                        --保证金
    ,MRGN_ACC                    --保证金账号
    ,LOAN_OFR_NO                 --信贷员工号
    ,ACCRD_INT                   --应计利息
    ,PRO_IMPT                    --减值准备
    ,COM_PRO                     --一般准备
    ,SPCL_PRO                    --专项准备
    ,ESP_PRO                     --特别准备
    ,SPCL_LOAN_FLG               --专项贷款标志
    ,ORIG_RCPT_NO                --原借据号
    ,FND_PCT                     --出资比例
    ,ETR_ACC                     --入账账号
    ,ETR_ACC_NM                  --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM   --贷款入账账号开户行名称
    ,REPY_ACC                    --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM  --贷款还款账号开户行名称
    ,RCPT_STAT                   --借据状态
    ,ACC_STAT                    --账户状态
    ,REV_LOAN_FLG                --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG        --关系人保证贷款标志
    ,BEAR_OR_RED_AMT             --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                --境内外标志
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    ,LMT_CONT_ID                 --额度合同编号
    ,GXH_PAY_TYPE                --还款方式
    ,GXH_PAY_FREQ                --还款频度
    ,ASSET_TRAN_DT               --资产转让日期
    ,LOAN_DIR_BIO_FLG            --贷款投向境内外标识
    ,REFAC_FLG                   --支小再贷款标识
    ,BILL_ACT_AMT                --转帖现、福费廷的贷款金额取实付金额
    ,LOAN_MODAL_CD               --贷款形态代码
    ,OPER_ORG_ID                 --经办机构编号
    ,OPER_TELLER_ID              --经办柜员编号
    ,LOAN_ACT_FIRST_DT           --本行首贷日期
    ,RENEW_EXP_DAY               --展期到期日期
    ,FIR_LON_DT                  --征信首贷日期
    ,LOAN_MGR_ID                 --借据主办客户经理号
    ,LOAN_TELLER_ID              --借据主办柜员号
    ,LOAN_MGR_NAME               --借据主办客户经理名称
    ,LOAN_MGR_BELONG_ORG_ID      --借据主办客户经理所属机构
    ,CNCL_DT                     --核销日期
    ,FIXED_INT_MARK              --利率是否固定
    ,IN_BS_INT                   --表内利息
    ,OFF_BS_INT                  --表外利息
    ,DISTR_AMT                   --放款金额
    ,DISTR_DT                    --放款日期
    ,EAST_FLG                    --EAST口径标识
    ,CTR_NT_ID                   --成交单编号
    ,RECVBL_PNLT                 --应收罚息
    ,COLL_PNLT                   --催收罚息
    ,RECVBL_COMP_INT             --应收复息
    ,RECVBL_INT_SUB              --应收贴息
    ,RECVBL_FINE                 --应收罚息
    ,RECVBL_OVER_INT             --应收欠息
    ,COLL_OVER_INT               --催收欠息
    ,LOAN_USEAGE_SUB_CL          --贷款用途细类
    ,CUST_CHAR                   --客户性质
    ,OUT_ACCT_FLOW_NUM           --出账流水号
    ,ICMS_CUST_ID                --信贷客户编号
    ,LC_BENEFC                   --信用证受益人
    ,FIX_INT_RAT_FLG             --固定利率标志
    ,LC_ISSUER                   --信用证开证人
    ,BASE_RAT_IMAS               --基准利率IMAS    --ADD BY LIP 20230810
    ,ABS_FLG                     --资产证券化标志
    ,ASSET_TRAN_FLG              --资产转让标志
    ,REPL_OLD_BOND_FLG           --置换旧债标志    --ADD BY yjy 20240401
    ,RENEW_FLG_WDQ               --展期未到期标志  --ADD BY LWB 20240408
    ,PAYOFF_DT                   --结清日期        --ADD BY YJY 20241022
    ,SUIT_FEE_BAL                --诉讼费余额      --ADD BY YJY 20241217
    ,GREEN_CRDT_CLS_NEW          --绿色信贷分类_新版代码 --ADD BY YJY 20250508
    ,YBT_FLG                     --一表通口径标识 --ADD BY PSF 20250916
    ,SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
    )
    WITH CMM_UNITE_WL_LMT_INFO_QC AS ( --MOD BY YJY 20250425 取微业贷的额度合同号
  SELECT T.CUST_ID                            AS CUST_ID          --客户号
        /*,T.LMT_CONT_ID                        AS LMT_CONT_ID      --额度合同编号*/
        --UPDATE BY YJY 20260413 203050100002-微众对公联合贷的取联合贷额度信息表的LMT_RELA_APPL_ID--额度关联申请编号，其他产品取LMT_CONT_ID--额度合同编号
        ,CASE WHEN T.BUS_BREED_ID = '203050100002' THEN T.LMT_RELA_APPL_ID
              ELSE T.LMT_CONT_ID
          END                                 AS LMT_CONT_ID      --额度合同编号
        ,T.CRDT_LMT                           AS CRDT_LMT         --授信额度
        ,T.STATUS_CD                          AS STATUS_CD        --状态代码
        ,T.LOW_RISK_BUS_FLG                   AS LOW_RISK_BUS_FLG --低风险业务标志
        ,T.CRDT_OPEN_AMT                      AS CRDT_OPEN_AMT    --合同敞口金额
        ,MIN(T.BEGIN_DT)OVER(PARTITION BY T.CUST_ID,T.BUS_BREED_ID) AS BEGIN_DT      --授信起始日期
        ,CASE WHEN TO_CHAR(T.EXP_DT,'YYYYMMDD') NOT IN ('00010101','20991231','29991231')
              THEN T.EXP_DT
          END                                 AS EXP_DT           --授信到期日期
        ,T.BUS_BREED_ID                       AS BUS_BREED_ID1    --统一后的授信品种
        --一个客户在一个业务品种中可能有多次审批记录，取当前最新的一个额度为准 --梁秋茹/杨光泽
        ,ROW_NUMBER()OVER(PARTITION BY T.CUST_ID,T.BUS_BREED_ID ORDER BY T.BEGIN_DT DESC,T.LMT_CONT_ID DESC) AS RN --去重
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO T --联合网贷额度信息
   WHERE TRIM(T.CUST_ID) IS NOT NULL
     AND T.CRDT_LMT > 0
     AND (NVL(T.BEGIN_DT,TO_DATE('00010101','YYYYMMDD')) <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
          OR T.BEGIN_DT IN (TO_DATE('20991231','YYYYMMDD'),TO_DATE('99991231','YYYYMMDD')))
     AND T.BUS_BREED_ID IN ('203050100001','203050100002') --203050100001-微业贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+PRALLEL(4)*/
         V_P_DATE                                                        AS DATA_DT                     --数据日期
        ,A.LP_ID                                                         AS LGL_REP_ID                  --法人编号
        ,A.DUBIL_ID                                                      AS ACC_ID                      --账户编号
        --MOD BY 20250725 回退核算改造前版本
        ,A.DUBIL_ID                                                      AS RCPT_ID                     --借据编号
        ,A.CORE_DUBIL_ID                                                 AS THIRD_RCPT_ID               --内部借据号 --MOD BY LIP 20250725 IMAS发放日期20250703-20250723的借据使用
        ,A.CONT_ID                                                       AS CONT_ID                     --合同编号 MOD BY YJY 20250604 取真实合同号
        ,A.DUBIL_ID                                                      AS BILL_NO                     --票据号码
        ,NULL                                                            AS COOP_AGRT_ID                --合作协议编号
        ,A.CUST_ID                                                       AS CUST_ID                     --客户编号
        ,A.ACCT_INSTIT_ID                                                AS ORG_ID                      --机构编号
        ,A.SUBJ_ID                                                       AS SUBJ_ID                     --科目编号
        ,A.STD_PROD_ID                                                   AS LOAN_STD_PROD_ID            --贷款标准产品编号
        ,B.PROD_NAME                                                     AS LOAN_STD_PROD_NM            --贷款标准产品名称
        ,A.STD_PROD_ID                                                   AS LOAN_PROD_ID                --贷款产品编号
        ,B.PROD_NAME                                                     AS LOAN_PROD_NM                --贷款产品名称
        ,NVL(TA.TAR_VALUE_CODE,A.STD_PROD_ID)                            AS LOAN_BIZ_TYP                --贷款业务类型
        ,A.CURR_CD                                                       AS CUR                         --币种
        ,A.DUBIL_AMT                                                     AS LOAN_AMT                    --借款金额
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE A.CURRT_BAL
         END                                                             AS LOAN_BAL                    --贷款余额
        ,0                                                               AS INT_ADJ                     --利息调整
        ,0                                                               AS FAIR_VAL_CHG                --公允价值变动
        ,CASE WHEN A.WRT_OFF_FLG = '1' THEN 0
              ELSE NVL(A.OVDUE_PRIC,0) + NVL(A.IDLE_PRIC,0)
         END                                                             AS OVD_PRIN_BAL                --逾期本金余额
        ,/*A.IN_BS_INT*/A.IN_BS_OVER_INT_BAL                             AS IN_INT_OVD_BAL              --表内欠息余额 --MOD BY YJY 20250414
        ,/*A.OFF_BS_INT*/A.OFF_BS_OVER_INT_BAL                           AS OUT_INT_OVD_BAL             --表外欠息余额 --MOD BY YJY 20250414
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                                  AS LOAN_ACT_DSTR_DT            --贷款实际发放日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                    AS LOAN_ORIG_EXP_DT            --贷款原始到期日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                    AS LOAN_ACT_EXP_DT             --贷款实际到期日期
        ,CASE WHEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               AND D.FIR_WRT_OFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')
              WHEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
              THEN TO_CHAR(A.PAYOFF_DT,'YYYYMMDD') --MOD BY LIP 20251113
              ELSE '29991231'
          END                                                            AS ACT_END_DT                  --实际终止日期
        ,TO_CHAR(A.LAST_REPAY_DT,'YYYYMMDD')                             AS LAST_REPY_DT                --上次还款日期
        ,M1.LAST_REPY_AMT                                                AS LAST_REPY_AMT               --上次还款金额
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')                                  AS VAL_DT                      --起息日期
        ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')                              AS OPEN_ACC_DT                 --开户日期
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')                                 AS CNL_ACC_DT                  --销户日期
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.PRIC_OVDUE_DAYS,'YYYYMMDD')
          END                                                            AS PRIN_OVD_DT                 --本金逾期日期
        ,CASE WHEN A.INT_OVDUE_DAYS > 0
              THEN TO_CHAR(A.ETL_DT - A.INT_OVDUE_DAYS,'YYYYMMDD')
          END                                                            AS INT_OVD_DT                  --利息逾期日期
        ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS)                    AS OVD_DAYS                    --逾期天数
        ,CASE WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS > 0 THEN '03'  --03：本金利息逾期
              WHEN A.PRIC_OVDUE_DAYS > 0 AND A.INT_OVDUE_DAYS = 0 THEN '01'  --01：本金逾期
              WHEN A.PRIC_OVDUE_DAYS = 0 AND A.INT_OVDUE_DAYS > 0 THEN '02'  --02：利息逾期
              ELSE NULL
          END                                                            AS OVD_TYP                     --逾期类型
        ,C.CD_DESCB                                                      AS LOAN_USEAGE                 --贷款用途
        ,TB.TAR_VALUE_CODE                                               AS LVL5_CL                     --五级分类
        ,TI.TAR_VALUE_CODE                                               AS GUA_MODE                    --担保方式
        ,CASE WHEN G.RG_CD = '810000' THEN 'HKG'
              WHEN G.RG_CD = '820000' THEN 'MAC'
              WHEN G.RG_CD = '710000' THEN 'TWN'
              WHEN NVL(TRIM(G.INVTOR_CTY_CD), '1111') NOT IN ('CHN', 'XXX', '1111')
              THEN TRIM(G.INVTOR_CTY_CD)
              WHEN TRIM(G.RG_CD) NOT IN ('1000','999999','000000')
              THEN TRIM(G.RG_CD)
              WHEN TRIM(F.DIST_CD) NOT IN ('1000','999999','000000')
              THEN TRIM(F.DIST_CD)
          END                                                            AS LOAN_DIR_RGN               --贷款投向地区
        ,CASE WHEN /*A.DIR_INDUS_CD*/ E.DIR_INDUS_CD = '-' THEN 'Z'
              ELSE NVL(/*A.DIR_INDUS_CD*/ E.DIR_INDUS_CD,'Z')
          END                                                            AS LOAN_DIR_IDY               --贷款投向行业  --MOD BY YJY 20250508
        ,'N'                                                             AS SYN_LOAN_FLG               --银团贷款标志
        ,'N'                                                             AS PROJ_LOAN_FLG              --项目贷款标志
        ,NULL                                                            AS IDY_STRU_ADJ_TYP           --产业结构调整类型
        ,CASE WHEN E.INDU_CORP_TECH_REM_UGD_FLG = '1' THEN 'Y'
              ELSE 'N'
         END                                                              AS IDY_TRNST_UPG_FLG          --工业转型升级标志  MOD BY YJY 20250508
        ,CASE WHEN E.STRATE_NEW_INDUS_TYPE_CD = '1' THEN 'Y'
              ELSE 'N'
         END                                                             AS STRTG_EMER_IDY_TYP         --战略新兴产业类型   MOD BY YJY 20250508
        ,'N'                                                             AS BANK_TAX_COOP_LOAN_FLG     --银税合作贷款标志
        ,CASE WHEN REPLACE(E.AGCLT_LOAN_DIR_CD,'-',NULL) IS NOT NULL
              THEN 'Y'
              ELSE 'N'
         END                                                             AS AGR_REL_LOAN_FLG           --涉农贷款标志    --MOD BY YJY 20250508
        ,CASE WHEN E.ESTATE_LOAN_TYPE_CD IS NULL THEN 'N'
              ELSE 'Y'
         END                                                             AS RL_EST_LOAN_FLG            --房地产贷款标志 MOD BY YJY 20250508
        ,NULL                                                            AS IALL_LOAN_FLG              --投贷联动贷款标志
        ,NULL                                                            AS OV_SEA_MRG_LOAN_FLG        --境外并购贷款标志
        ,NULL                                                            AS GRN_LOAN_USEAGE_CL         --绿色贷款用途分类
        ,CASE WHEN E.BUID_BUS_GUAR_LOAN_FLG = '1' THEN 'Y'
              ELSE 'Y'
         END                                                             AS ENT_GUA_LOAN_TYP           --创业担保贷款类型 MOD BY YJY 20250508
        ,NULL                                                            AS CAMPUS_CNSMP_LOAN_FLG      --校园消费贷款标志
        ,NULL                                                            AS LCL_GOVFINPLTF_LOAN_FLG    --地方政府融资平台贷款标志  暂定
        ,NULL                                                            AS LAND_THIRDPARTY_LOAN_TYP   --将承包土地的经营权抵押给第三方的担保贷款类型
        ,NULL                                                            AS FARMER_THIRDPARTY_LOAN_TYP --将农民住房财产权抵押给第三方的担保贷款类型
        ,NULL                                                            AS POV_ALLE_REC_FLG           --未脱贫建档立卡户贷款标志
        ,'03'                                                            AS LOAN_HDL_CHAN              --贷款办理渠道   mod by yjy 20250414 第三方互联网平台
        ,CASE WHEN A.STD_PROD_ID IN ('203050100002') THEN 'N' --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE 'Y'   
         END                                                             AS NET_LOAN_FLG               --互联网贷款标志
        ,CASE WHEN A.STD_PROD_ID IN ('203050100002') THEN '3' --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
              ELSE '1'   
         END                                                             AS NET_LOAN_PROD_TYP          --网贷产品类别   暂定
        ,NULL                                                            AS CR_CRD_BIZ_OD_TYP          --类信用卡业务透支类型
        ,TC.TAR_VALUE_CODE                                               AS REPY_MODE                  --还款方式
        ,CASE WHEN WHBXD.DUBIL_ID IS NOT NULL THEN '05' --05-无还本续贷
              ELSE '01'
         END                                                             AS LOAN_FRM                   --贷款形式
        ,CASE WHEN A.REGROUP_FLG = '1' THEN 'Y'
              ELSE 'N'
         END                                                             AS RCMM_LOAN_FLG              --重组贷款标识
        ,NULL                                                            AS ADJ_BAD_FLG                --下调为不良标志
        ,NULL                                                            AS ALDY_RCMM_FLG              --曾重组标志
        ,NULL                                                            AS CTON_PRD_LOAN_FLG          --缩期贷款标志
        ,NULL                                                            AS CASH_TRF_FLG               --现转标志
        ,DECODE(H1.DUBIL_ID, NULL,'N', 'Y')                              AS FST_LOAN_FLG               --首贷户贷款标志
        ,DECODE(H1.DUBIL_ID, NULL,'N', 'Y')                              AS FIRST_LOAN_FLG             --首次贷款标志
        ,CASE --WHEN NVL(G.GREEN_CRDT_CLS_NEW,'-') <> '-'
              WHEN NVL(TRIM(G.GREEN_CRDT_CLS_NEW),'-') NOT IN ('-','999')
              THEN 'Y'
              ELSE 'N'
          END                                                            AS PBOC_GRN_LOAN_FLG          --PBOC绿色贷款标志  -MOD BY YJY 20250604 --MOD BY YJY 20250819
        ,CASE --WHEN SUBSTR(/*G.GREEN_CRDT_CLS_CD*/G.GREEN_CRDT_CLS_NEW,1,1) IN ('A','B','C','D','E','F') --MOD BY YJY 20250604 --MOD BY YJY 20250819 从借据表取绿色信贷分类_新版代码
              WHEN NVL(TRIM(G.GREEN_CRDT_CLS_NEW),'-') NOT IN ('-','999')
              THEN 'Y'
              ELSE 'N'
          END                                                            AS CBRC_GRN_LOAN_FLG           --CBRC绿色贷款标志
        ,NULL                                                            AS CNSMP_SCN_LOAN_FLG          --消费场景贷款标志
        ,TJ.TAR_VALUE_CODE                                               AS LOAN_FINC_SPT_MODE          --贷款财政扶持方式 --MOD BY YJY 20250508
        ,NULL                                                            AS ACURT_POV_ALLE_LOAN_FLG     --精准扶贫贷款标志
        ,TO_CHAR(A.NEXT_INT_RAT_ADJ_DT,'YYYYMMDD')                       AS RATE_RE_PRC_DT              --利率重新定价日期
        ,CASE WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1D' THEN '01'--按日
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD IN ('7D','1W') THEN '02'--按周
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '1M' THEN '03'--按月
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '3M' THEN '04'--按季
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '6M' THEN '05'--按半年
              WHEN A.INT_RAT_ADJ_PED_FREQ||A.INT_RAT_ADJ_PED_CORP_CD = '12M' THEN '06'--按年
              ELSE '99'
          END                                                            AS RATE_FLT_FREQ               --利率浮动频率
        ,TH.TAR_VALUE_CODE                                               AS RATE_TYP                    --利率类型
        ,NULL                                                            AS AST_SCRTZ_PROD_ID           --资产证券化产品编号
        ,A.EXEC_INT_RAT                                                  AS EXEC_RATE                   --执行利率
        ,A.BASE_RAT                                                      AS BASE_RATE                   --基准利率
        ,NULL                                                            AS CNTR_GUA_LOAN_FLG           --反担保贷款标志
        ,A.INT_RAT_FLO_VAL                                               AS RATE_FLT_VAL                --利率浮动值
        ,TE.TAR_VALUE_CODE                                               AS PRC_BASE_TYP                --定价基准类型
        ,CASE WHEN (A.PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') OR A.TOT_PERDS = 0)
              THEN A.CURR_ISSUE_PERDS --因还款计划会删除，所以如果总期数为0，则取当前期数
              WHEN NVL(A.TOT_PERDS,0) > 0
              THEN NVL(A.TOT_PERDS,0)
              ELSE A.TOT_PERDS
          END                                                             AS TOT_PRD_NUM                 --总期数
        ,NVL(A.CURR_ISSUE_PERDS,0)                                        AS CURR_PRD                    --当前期数
        ,NVL(I.LJQKQS,0)                                                  AS CUM_DEBT_PRD_NUM            --累计欠款期数
        ,NVL(I.LXQKQS,0)                                                  AS CNU_DEBT_PRD_NUM            --连续欠款期数
        ,CASE WHEN A.TOT_PERDS < A.CURR_ISSUE_PERDS THEN 1
              ELSE 0
          END                                                              AS EXTN_CNT                   --展期次数
        ,'01'                                                              AS DSBR_MODE                  --放款方式
        ,NVL(TD.TAR_VALUE_CODE,'9901')                                     AS INT_CALC_MODE              --计息方式
        ,NULL                                                              AS MRGN_PCT                   --保证金比例
        ,NULL                                                              AS MRGN_CUR                   --保证金币种
        ,NULL                                                              AS MRGN                       --保证金
        ,NULL                                                              AS MRGN_ACC                   --保证金账号
        ,CASE WHEN TRIM(A.CUST_MGR_ID) IS NOT NULL
               AND TRIM(A.CUST_MGR_ID) <> 'M0001'
              THEN TRIM(A.CUST_MGR_ID)
          END                                                              AS LOAN_OFR_NO                --信贷员工号
        ,A.CURRT_ACRU_INT                                                  AS ACCRD_INT                  --应计利息
        ,NULL                                                              AS PRO_IMPT                   --减值准备
        ,NULL                                                              AS COM_PRO                    --一般准备
        ,NULL                                                              AS SPCL_PRO                   --专项准备
        ,NULL                                                              AS ESP_PRO                    --特别准备
        ,NULL                                                              AS SPCL_LOAN_FLG              --专项贷款标志
        ,NULL                                                              AS ORIG_RCPT_NO               --原借据号
        ,A.BANK_CONTRI_RATIO * 100                                         AS FND_PCT                    --出资比例
        ,TRIM(A.ENTER_ACCT_ACCT_NUM)                                       AS ETR_ACC                    --入账账号
        ,NVL(TRIM(E.RECVBL_ACCT_NAME),G.CUST_NAME)                         AS ETR_ACC_NM                 --入账账号户名
        ,NVL(TRIM(A.ENTER_ACCT_BANK_NAME),TRIM(A.REPAY_OPEN_ACCT_ORG_NAME))AS LOAN_ETR_ACC_OPEN_BANK_NM  --贷款入账账号开户行名称
        ,NVL(TRIM(A.REPAY_NUM),TRIM(A.ENTER_ACCT_ACCT_NUM))                AS REPY_ACC                   --还款账号
        ,NVL(TRIM(A.REPAY_OPEN_ACCT_ORG_NAME),TRIM(A.ENTER_ACCT_BANK_NAME))AS LOAN_REPY_ACC_OPEN_BANK_NM --贷款还款账号开户行名称
        ,TF.TAR_VALUE_CODE                                                 AS RCPT_STAT                  --借据状态
        ,TG.TAR_VALUE_CODE                                                 AS ACC_STAT                   --账户状态
        ,'N'                                                               AS REV_LOAN_FLG               --循环贷贷款标志
        ,NULL                                                              AS REL_PSN_GUA_LOAN_FLG       --关系人保证贷款标志
        ,NULL                                                              AS BEAR_OR_RED_AMT            --承担或减免的信贷费用金额
        ,'Y'                                                               AS BIO_LOAN_FLG               --境内外标志 默认境内
        ,NULL                                                              AS DEPT_LINE                  --部门条线
        ,'对公联合网贷'                                                    AS DATA_SRC                   --数据来源
        /*,SX.LMT_CONT_ID                                                    AS LMT_CONT_ID                --额度合同编号 mod by yjy 20250425*/
        --UPDATE BY YJY 20260413 优先取授信申请表中最新的授信，没有授信时用借据号做授信合同号
        ,NVL(SX.LMT_CONT_ID,A.DUBIL_ID)                                    AS LMT_CONT_ID                --额度合同编号 
        ,A.REPAY_WAY_CD                                                    AS GXH_PAY_TYPE               --还款方式
        ,A.PRIC_REPAY_FREQ_CD                                              AS GXH_PAY_FREQ               --还款频率
        ,NULL                                                              AS ASSET_TRAN_DT              --资产转让日期
        ,CASE WHEN A.DOM_OVERS_FLG = '1' THEN 'N'--境外
              WHEN A.DOM_OVERS_FLG = '0' THEN 'Y'--境内
              ELSE 'Y' --未知
          END                                                              AS LOAN_DIR_BIO_FLG           --贷款投向境内外标识
        ,'N'                                                               AS REFAC_FLG                  --支小再贷款标识
        ,NULL                                                              AS BILL_ACT_AMT               --转帖现、福费廷的贷款金额取实付金额
        ,NULL                                                              AS LOAN_MODAL_CD              --贷款形态代码
        ,NULL                                                              AS OPER_ORG_ID                --经办机构编号
        ,NULL                                                              AS OPER_TELLER_ID             --经办柜员编号
        ,H2.LOAN_ACT_DSTR_DT                                               AS LOAN_ACT_FIRST_DT          --本行首贷日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                                      AS RENEW_EXP_DAY              --展期到期日期
        ,NULL                                                              AS FIR_LON_DT                 --征信首贷日期
        ,TRIM(A.CUST_MGR_ID)                                               AS LOAN_MGR_ID                --借据主办客户经理号
        ,TRIM(A.CUST_MGR_ID)                                               AS LOAN_TELLER_ID             --借据主办柜员号
        ,NULL                                                              AS LOAN_MGR_NAME              --借据主办客户经理名称
        ,NULL                                                              AS LOAN_MGR_BELONG_ORG_ID     --借据主办客户经理所属机构
        ,TO_CHAR(D.FIR_WRT_OFF_DT,'YYYYMMDD')                              AS CNCL_DT                    --核销日期
        ,A.INT_RAT_ADJ_WAY_CD                                              AS FIXED_INT_MARK             --利率是否固定
        ,A.IN_BS_INT                                                       AS IN_BS_INT                  --表内利息
        ,A.OFF_BS_INT                                                      AS OFF_BS_INT                 --表外利息
        ,A.DISTR_AMT                                                       AS DISTR_AMT                  --放款金额
        ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')                                    AS DISTR_DT                   --放款日期
        ,CASE WHEN A.WRT_OFF_FLG = '1'
               AND (D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE - 1)
              THEN 'Y' --核销过且核销日期大于月初
              WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销过的且核销日期小于月初的
              WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN 'Y' --结清日期为空
              WHEN A.PAYOFF_DT < V_MONTH_START_DATE - 1 THEN 'N' --结清日期小于月初
              WHEN A.PAYOFF_DT >= V_MONTH_START_DATE - 1 THEN 'Y' --结清日期大于月初
              ELSE 'N'
         END                                                                AS EAST_FLG                  --EAST口径标识 暂定
        ,NULL                                                               AS CTR_NT_ID                 --成交单编号
        ,A.RECVBL_PNLT                                                      AS RECVBL_PNLT               --应收罚息
        ,NULL                                                               AS COLL_PNLT                 --催收罚息
        ,NULL                                                               AS RECVBL_COMP_INT           --应收复息
        ,NULL                                                               AS RECVBL_INT_SUB            --应收贴息
        ,NULL                                                               AS RECVBL_FINE               --应收罚金
        ,A.RECVBL_OVER_INT                                                  AS RECVBL_OVER_INT           --应收欠息
        ,NULL                                                               AS COLL_OVER_INT             --催收欠息
        ,NULL                                                               AS LOAN_USEAGE_SUB_CL        --贷款用途细类
        ,NULL                                                               AS CUST_CHAR                 --客户性质
        ,NULL                                                               AS OUT_ACCT_FLOW_NUM         --出账流水号
        ,A.CUST_ID                                                          AS ICMS_CUST_ID              --信贷客户编号
        ,NULL                                                               AS LC_BENEFC                 --信用证受益人
        ,NULL                                                               AS FIX_INT_RAT_FLG           --固定利率标志
        ,NULL                                                               AS LC_ISSUER                 --信用证开证人
        ,A.BASE_RAT                                                         AS BASE_RAT_IMAS             --基准利率IMAS
        ,NULL                                                               AS ABS_FLG                   --资产证券化标志
        ,NULL                                                               AS ASSET_TRAN_FLG            --资产转让标志
        ,NULL                                                               AS REPL_OLD_BOND_FLG         --置换旧债标志
        ,NULL                                                               AS RENEW_FLG_WDQ             --展期未到期贷款
        ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')                                    AS PAYOFF_DT                 --结清日期
        ,NULL                                                               AS SUIT_FEE_BAL              --诉讼费余额
        ,G.GREEN_CRDT_CLS_NEW                                               AS GREEN_CRDT_CLS_NEW        --绿色信贷分类_新版代码 --ADD BY YJY 20250508
        ,CASE WHEN A.WRT_OFF_FLG = '1'
               AND (D.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(D.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE - 1)
              THEN 'Y' --核销过且核销日期大于年初
              WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销过的且核销日期小于年初的
              WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN 'Y' --结清日期为空
              WHEN A.PAYOFF_DT < V_YEAR_START_DATE - 1 THEN 'N' --结清日期小于年初
              WHEN A.PAYOFF_DT >= V_YEAR_START_DATE - 1 THEN 'Y' --结清日期大于年初
              ELSE 'N'
         END                                                                AS YBT_FLG                  --YBT口径标识 --ADD BY PSF 20250916
        ,NULL                                                               AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
        ,NULL                                                               AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
        ,NULL                                                               AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO B --标准产品信息表
      ON B.PROD_ID = A.STD_PROD_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD C  --公共代码表 取贷款用途
      ON C.CD_ID = 'CD1274'
     AND C.CD_VAL = A.LOAN_USAGE_CD
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO D --联合网贷核销信息
      ON D.DUBIL_ID = A.DUBIL_ID
     AND D.STD_PROD_ID IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO E --联合网贷贷款合同信息
      ON E.CONT_ID = A.CONT_ID
     AND E.STD_PROD_ID IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
      ON F.PARTY_ID = A.CUST_ID
     AND F.PHYS_ADDR_TYPE_CD = /*'001001'*/ '06' --办公营业地址 MOD BY YJY 20260119
     AND F.SRC_SYS_CD = 'CRSS'
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO G --对公客户基本信息
      ON G.CUST_ID = A.CUST_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DUBIL_ID
                 FROM (SELECT DUBIL_ID
                             ,ROW_NUMBER() OVER(PARTITION BY CUST_ID ORDER BY DISTR_DT,DUBIL_ID ASC) AS RN
                        FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO
                       WHERE ETL_DT = TO_DATE(I_P_DATE,'YYYYMMDD')
                        AND STD_PROD_ID IN ('203050100001','203050100002') )--MOD BY YJY 20251120 新增203050100002-微众对公联合贷
                WHERE RN = 1) H1 --取首次贷款借据
      ON H1.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP00 H2 --取是否首贷日期
      ON H2.RCPT_ID = A.DUBIL_ID
    --MOD BY YJY 20251104 从临时表取值
    LEFT JOIN RRP_MDL.M_LOAN_DUBILL_UNITE_WL_REPAY_PLAN_TMP I --联合网贷还款计划 取连续/累计欠款期数
      ON I.DUBIL_ID = A.DUBIL_ID
     AND I.PROD_ID IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
    LEFT JOIN (SELECT DUBIL_ID
                     ,REPAY_DT  --还款日期
                     ,SUM(CURRT_REPAY_PRIC + CURR_REPAY_INT + CURRT_REPAY_PNLT + CURRT_REPAY_FEE) AS LAST_REPY_AMT
                 FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL  --联合网贷还款明细
                WHERE PROD_ID IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
                GROUP BY DUBIL_ID,REPAY_DT) M1  --（取上次交易金额）
      ON M1.DUBIL_ID = A.DUBIL_ID
     AND M1.REPAY_DT = A.LAST_REPAY_DT
    --MOD BY YJY 20250103  获取信贷系统无还本续贷为“是”的借据
    LEFT JOIN (SELECT A.OBJECTNO AS DUBIL_ID  --业务流水号
                 FROM RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA A --标签值最终表
                INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG B --标签码值配置表
                   ON B.TAGID = A.TAGID --标签编号
                  AND B.ITEMNO = A.TAGVALUE --标签值
                  AND B.ITEMNAME = '是'
                  AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE A.TAGHIREARCHY = '60' --标签层级
                  AND A.TAGID = '2024120900000002' --标签编号：是否无还本续贷
                  AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) WHBXD  --无还本续贷
      ON WHBXD.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.CODE_MAP TA --码值映射表(贷款业务类别)
      ON TA.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TA.SRC_CLASS_CODE = 'STD0002'
     AND TA.TAR_CLASS_CODE = 'T0001'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --码值映射表(贷款五级分类)
      ON TB.SRC_VALUE_CODE = A.LOAN_LEVEL5_CLS_CD
     AND TB.SRC_CLASS_CODE = 'CD1032'
     AND TB.TAR_CLASS_CODE = 'D0005'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --码值映射表(还款方式)
      ON TC.SRC_VALUE_CODE = A.INT_SET_WAY_CD
     AND TC.SRC_CLASS_CODE = 'CD1007'
     AND TC.TAR_CLASS_CODE = 'D0103'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TD --码值映射表(计息形式)
      ON TD.SRC_VALUE_CODE = A.INT_SET_WAY_CD
     AND TD.SRC_CLASS_CODE = 'CD1007'
     AND TD.TAR_CLASS_CODE = 'D0061'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TE --码值映射表(利率种类转码)
      ON TE.SRC_VALUE_CODE = A.INT_RAT_BASE_TYPE_CD
     AND TE.SRC_CLASS_CODE = 'CD1010'
     AND TE.TAR_CLASS_CODE = 'Z0015'
     AND TE.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TF   --码值映射表（借据状态）
      ON TF.SRC_VALUE_CODE = A.DUBIL_STATUS_CD
     AND TF.SRC_CLASS_CODE = 'CD1261'
     AND TF.TAR_CLASS_CODE = 'D0007'
     AND TF.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TG   --码值映射表(账户状态)转码
      ON TG.SRC_VALUE_CODE = A.DUBIL_STATUS_CD
     AND TG.SRC_CLASS_CODE = 'CD1261'
     AND TG.TAR_CLASS_CODE = 'Z0018'
     AND TG.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TH --码值映射表(利率类型转码)
      ON TH.SRC_VALUE_CODE = A.INT_RAT_FLOAT_WAY_CD
     AND TH.SRC_CLASS_CODE = 'CD1016'
     AND TH.TAR_CLASS_CODE = 'Z0007'
     AND TH.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TI --码值映射表(担保方式转码)
      ON TI.SRC_VALUE_CODE = A.GUAR_WAY_CD
     AND TI.SRC_CLASS_CODE = 'CD2656'
     AND TI.TAR_CLASS_CODE = 'D0002'
     AND TI.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TJ --贴息贷款类型
      ON TJ.SRC_VALUE_CODE = E.LOAN_FIN_SUPT_WAY_CD
     AND TJ.SRC_CLASS_CODE = 'D0016'--贴息贷款类型
     AND TJ.TAR_CLASS_CODE = 'D0016'
     AND TJ.MOD_FLG = 'MDM'
    -- MOD BY YJY 20250425 关联额度信息表，获取额度合同编号
    LEFT JOIN CMM_UNITE_WL_LMT_INFO_QC SX
      ON SX.CUST_ID = A.CUST_ID
     AND SX.BUS_BREED_ID1 =  A.STD_PROD_ID
     AND SX.RN = 1
   WHERE A.STD_PROD_ID IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
     AND A.DUBIL_ID IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20241122 处理票据的结清日期
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--票据贴现的结清日期';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP07';
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP07(
    RCPT_ID     --借据编号
   ,CNL_ACC_DT  --销户日期
   ,DATA_SRC    --数据来源
   )
    WITH SYS_IN_FLG_DISCOUNT AS ( --MOD BY LIP 20251111 贴现的结清日期，增加转贴现卖出的日期
  SELECT A.BILL_NUM,A.BILL_SUB_INTRV_ID,MIN(A.STL_DT) STL_DT
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
   WHERE A.TRAN_DIR_CD = '01' --买入
     AND A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03' --记账成功
     AND A.SYS_IN_FLG = '0' --系统内
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.BILL_NUM,A.BILL_SUB_INTRV_ID),
   RECS_AGREE_PAYOFF_APPL_H AS (
  SELECT T.BILL_NUM,T.AGREE_PAYOFF_DT,
         ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM ORDER BY T.AGREE_PAYOFF_DT DESC) RN
    FROM RRP_MDL.O_IML_AGT_RECS_AGREE_PAYOFF_APPL_H T
   WHERE T.RECV_OPINION_TYPE_CD = 'SU00'--签收意见类型代码：SU00：同意签收 SU01拒绝签收 其它:未知
     AND NVL(T.PAYOFF_APPL_INITOR_CD,'-') NOT IN ('W') --Y 银行端 我行发起的,W 网银端 客户发起的
     AND T.AGREE_PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT B.DUBIL_ID            AS RCPT_ID     --借据编号
        --,TO_CHAR(NVL(C.AGREE_PAYOFF_DT,A.INT_ACCR_EXP_DT),'YYYYMMDD') AS CNL_ACC_DT --销户日期
        ,TO_CHAR(COALESCE(D.STL_DT,C.AGREE_PAYOFF_DT,A.INT_ACCR_EXP_DT),'YYYYMMDD') AS CNL_ACC_DT --销户日期
        ,'票据贴现'            AS DATA_SRC    --数据来源
  FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO A
 INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
    ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)
   AND B.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
   AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN RECS_AGREE_PAYOFF_APPL_H C
    ON C.BILL_NUM = A.BILL_NUM
   AND C.RN = 1
  LEFT JOIN SYS_IN_FLG_DISCOUNT D
    ON D.BILL_NUM = A.BILL_NUM
   AND NVL(D.BILL_SUB_INTRV_ID,'-') = NVL(A.BILL_SUB_INTRV_ID,'-')
 WHERE A.DISCNT_STATUS_CD IN ('06')
   AND A.ENTRY_STATUS_CD = '03'
   AND ((A.BILL_STATUS_CD IN ('42') /*终止通知 CD1466*/ AND A.INT_ACCR_EXP_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
        OR C.BILL_NUM IS NOT NULL OR D.BILL_NUM IS NOT NULL)
   AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20241122 处理票据的结清日期
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--票据转贴现的结清日期';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP07(
    RCPT_ID     --借据编号
   ,CNL_ACC_DT  --销户日期
   ,DATA_SRC    --数据来源
   )
    WITH RECS_AGREE_PAYOFF_APPL_H AS (
  SELECT T.BILL_NUM,T.AGREE_PAYOFF_DT,
         ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM ORDER BY T.AGREE_PAYOFF_DT DESC) RN
    FROM RRP_MDL.O_IML_AGT_RECS_AGREE_PAYOFF_APPL_H T
   WHERE T.RECV_OPINION_TYPE_CD = 'SU00'--签收意见类型代码：SU00：同意签收 SU01拒绝签收 其它:未知
     AND NVL(T.PAYOFF_APPL_INITOR_CD,'-') NOT IN ('W') --Y 银行端 我行发起的,W 网银端 客户发起的
     AND T.AGREE_PAYOFF_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T3.DUBIL_ID           AS RCPT_ID     --借据编号
        ,TO_CHAR(COALESCE(T1.APPL_DT,C.AGREE_PAYOFF_DT,D.BUS_DT),'YYYYMMDD') AS CNL_ACC_DT  --销户日期
        ,'票据转贴现'          AS DATA_SRC    --数据来源
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO T2 --票据转贴现信息
   INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3
      ON T3.BILL_ID = T2.BILL_ID
     AND T3.STD_PROD_ID IN ('204010100001','204010100002') --新一代
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_SUGST_PAY_APPL_EVT T1 --提示付款申请事件
      ON T1.BILL_ID = T2.BILL_ID
     AND T1.APPL_TRAN_TYPE_CD = '01'
     AND T1.ENTRY_STATUS_CD = '03'
     AND T1.APPL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RECS_AGREE_PAYOFF_APPL_H C
      ON C.BILL_NUM = T2.BILL_NUM
     AND C.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO D
      ON D.BILL_ID = T2.BILL_ID
     AND D.BUS_TYPE_CD = 'BT01'
     AND D.ENTRY_STATUS_CD = '03' --记账成功 新票据
     AND D.TRAN_DIR_CD = '02'
     AND D.BUS_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (T1.BILL_ID IS NOT NULL OR C.BILL_NUM IS NOT NULL OR D.BILL_ID IS NOT NULL)
     AND T2.ENTRY_STATUS_CD = '03' --记账成功 新票据
     AND T2.TRAN_DIR_CD = '01'
     AND T2.BUS_TYPE_CD = 'BT01'
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表内借据信息--汇总';
  V_STARTTIME := SYSDATE;
  INSERT/*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_IN_DUBILL_INFO
    (DATA_DT                             --数据日期
    ,LGL_REP_ID                          --法人编号
    ,ACC_ID                              --账户编号
    ,RCPT_ID                             --借据编号
    ,THIRD_RCPT_ID                       --内部借据号 ADD BY YJY 20250521
    ,CONT_ID                             --合同编号
    ,BILL_NO                             --票据号码
    ,COOP_AGRT_ID                        --合作协议编号
    ,CUST_ID                             --客户编号
    ,ORG_ID                              --机构编号
    ,SUBJ_ID                             --科目编号
    ,LOAN_STD_PROD_ID                    --贷款标准产品编号
    ,LOAN_STD_PROD_NM                    --贷款标准产品名称
    ,LOAN_PROD_ID                        --贷款产品编号
    ,LOAN_PROD_NM                        --贷款产品名称
    ,LOAN_BIZ_TYP                        --贷款业务类型
    ,CUR                                 --币种
    ,LOAN_AMT                            --借款金额
    ,LOAN_BAL                            --贷款余额
    ,INT_ADJ                             --利息调整
    ,FAIR_VAL_CHG                        --公允价值变动
    ,OVD_PRIN_BAL                        --逾期本金余额
    ,IN_INT_OVD_BAL                      --表内欠息余额
    ,OUT_INT_OVD_BAL                     --表外欠息余额
    ,LOAN_ACT_DSTR_DT                    --贷款实际发放日期
    ,LOAN_ORIG_EXP_DT                    --贷款原始到期日期
    ,LOAN_ACT_EXP_DT                     --贷款实际到期日期
    ,ACT_END_DT                          --实际终止日期
    ,LAST_REPY_DT                        --上次还款日期
    ,LAST_REPY_AMT                       --上次还款金额
    ,VAL_DT                              --起息日期
    ,OPEN_ACC_DT                         --开户日期
    ,CNL_ACC_DT                          --销户日期
    ,PRIN_OVD_DT                         --本金逾期日期
    ,INT_OVD_DT                          --利息逾期日期
    ,OVD_DAYS                            --逾期天数
    ,OVD_TYP                             --逾期类型
    ,LOAN_USEAGE                         --贷款用途
    ,LVL5_CL                             --五级分类
    ,GUA_MODE                            --担保方式
    ,LOAN_DIR_RGN                        --贷款投向地区
    ,LOAN_DIR_IDY                        --贷款投向行业
    ,SYN_LOAN_FLG                        --银团贷款标志
    ,PROJ_LOAN_FLG                       --项目贷款标志
    ,IDY_STRU_ADJ_TYP                    --产业结构调整类型
    ,IDY_TRNST_UPG_FLG                   --工业转型升级标志
    ,STRTG_EMER_IDY_TYP                  --战略新兴产业类型
    ,BANK_TAX_COOP_LOAN_FLG              --银税合作贷款标志
    ,AGR_REL_LOAN_FLG                    --涉农贷款标志
    ,RL_EST_LOAN_FLG                     --房地产贷款标志
    ,IALL_LOAN_FLG                       --投贷联动贷款标志
    ,OV_SEA_MRG_LOAN_FLG                 --境外并购贷款标志
    ,GRN_LOAN_USEAGE_CL                  --绿色贷款用途分类
    ,ENT_GUA_LOAN_TYP                    --创业担保贷款类型
    ,CAMPUS_CNSMP_LOAN_FLG               --校园消费贷款标志
    ,LCL_GOVFINPLTF_LOAN_FLG             --地方政府融资平台贷款标志
    ,LAND_THIRDPARTY_LOAN_TYP            --将承包土地的经营权抵押给第三方的担保贷款类型
    ,FARMER_THIRDPARTY_LOAN_TYP          --将农民住房财产权抵押给第三方的担保贷款类型
    ,POV_ALLE_REC_FLG                    --未脱贫建档立卡户贷款标志
    ,LOAN_HDL_CHAN                       --贷款办理渠道
    ,NET_LOAN_FLG                        --互联网贷款标志
    ,NET_LOAN_PROD_TYP                   --网贷产品类别
    ,CR_CRD_BIZ_OD_TYP                   --类信用卡业务透支类型
    ,REPY_MODE                           --还款方式
    ,LOAN_FRM                            --贷款形式
    ,RCMM_LOAN_FLG                       --重组贷款标识
    ,ADJ_BAD_FLG                         --下调为不良标志
    ,ALDY_RCMM_FLG                       --曾重组标志
    ,CTON_PRD_LOAN_FLG                   --缩期贷款标志
    ,CASH_TRF_FLG                        --现转标志
    ,FST_LOAN_FLG                        --首贷户贷款标志
    ,FIRST_LOAN_FLG                      --首次贷款标志
    ,PBOC_GRN_LOAN_FLG                   --PBOC绿色贷款标志
    ,CBRC_GRN_LOAN_FLG                   --CBRC绿色贷款标志
    ,CNSMP_SCN_LOAN_FLG                  --消费场景贷款标志
    ,LOAN_FINC_SPT_MODE                  --贷款财政扶持方式
    ,ACURT_POV_ALLE_LOAN_FLG             --精准扶贫贷款标志
    ,RATE_RE_PRC_DT                      --利率重新定价日期
    ,RATE_FLT_FREQ                       --利率浮动频率
    ,RATE_TYP                            --利率类型
    ,AST_SCRTZ_PROD_ID                   --资产证券化产品编号
    ,EXEC_RATE                           --执行利率
    ,BASE_RATE                           --基准利率
    ,CNTR_GUA_LOAN_FLG                   --反担保贷款标志
    ,RATE_FLT_VAL                        --利率浮动值
    ,PRC_BASE_TYP                        --定价基准类型
    ,TOT_PRD_NUM                         --总期数
    ,CURR_PRD                            --当前期数
    ,CUM_DEBT_PRD_NUM                    --累计欠款期数
    ,CNU_DEBT_PRD_NUM                    --连续欠款期数
    ,EXTN_CNT                            --展期次数
    ,DSBR_MODE                           --放款方式
    ,INT_CALC_MODE                       --计息方式
    ,MRGN_PCT                            --保证金比例
    ,MRGN_CUR                            --保证金币种
    ,MRGN                                --保证金
    ,MRGN_ACC                            --保证金账号
    ,LOAN_OFR_NO                         --信贷员工号
    ,ACCRD_INT                           --应计利息
    ,PRO_IMPT                            --减值准备
    ,COM_PRO                             --一般准备
    ,SPCL_PRO                            --专项准备
    ,ESP_PRO                             --特别准备
    ,SPCL_LOAN_FLG                       --专项贷款标志
    ,ORIG_RCPT_NO                        --原借据号
    ,FND_PCT                             --出资比例
    ,ETR_ACC                             --入账账号
    ,ETR_ACC_NM                          --入账账号户名
    ,LOAN_ETR_ACC_OPEN_BANK_NM           --贷款入账账号开户行名称
    ,REPY_ACC                            --还款账号
    ,LOAN_REPY_ACC_OPEN_BANK_NM          --贷款还款账号开户行名称
    ,RCPT_STAT                           --借据状态
    ,ACC_STAT                            --账户状态
    ,REV_LOAN_FLG                        --循环贷贷款标志
    ,REL_PSN_GUA_LOAN_FLG                --关系人保证贷款标志
    ,BEAR_OR_RED_AMT                     --承担或减免的信贷费用金额
    ,BIO_LOAN_FLG                        --境内外标志
    ,DEPT_LINE                           --部门条线
    ,DATA_SRC                            --数据来源
    ,LMT_CONT_ID                         --额度合同编号
    ,GXH_PAY_TYPE                        --还款方式
    ,GXH_PAY_FREQ                        --还款频率
    ,ASSET_TRAN_DT                       --资产转让日期
    ,EAST_FLG                            --EAST口径标识
    ,LOAN_DIR_BIO_FLG                    --贷款投向境内外标识
    ,OVD_INT_BAL                         --逾期利息金额
    ,LOAN_CRDT_LMT_TOT                   --单户授信额度
    ,REFAC_FLG                           --支小再贷款标识
    ,BILL_ACT_AMT                        --贴现、转贴现实付金额
    ,LOAN_MODAL_CD                       --贷款形态代码
    ,OPER_ORG_ID                         --经办机构编号 add by hulj 20221123
    ,OPER_TELLER_ID                      --经办柜员编号 add by hulj 20221123
    ,LOAN_ACT_FIRST_DT                   --本行首贷日期 add by hulj 20221123
    ,RENEW_EXP_DAY                       --展期到期日期 add by hulj 20221123
    ,FIR_LON_DT                          --征信首贷日期 add by hulj 20221123
    ,LOAN_MGR_ID                         --借据主办客户经理号 add by hulj 20221123
    ,LOAN_TELLER_ID                      --借据主办柜员号 add by hulj 20221123
    ,LOAN_MGR_NAME                       --借据主办客户经理名称 add by hulj 20221123
    ,LOAN_MGR_BELONG_ORG_ID              --借据主办客户经理所属机构 add by hulj 20221123
    ,CNCL_DT                             --核销日期
    ,FIXED_INT_MARK                      --利率是否固定（与利率类型不一致）
    ,DISCNT_CUST_ID                      --直贴人客户号
    ,SYS_IN_FLG
    ,IN_BS_INT                           --表内利息
    ,OFF_BS_INT                          --表外利息
    ,HOLD_DAYS                           --持票天数
    ,DISTR_AMT                           --放款金额
    ,DISTR_DT                            --放款日期
    ,CTR_NT_ID                           --成交单编号
    ,RECVBL_PNLT                         --应收罚息
    ,COLL_PNLT                           --催收罚息
    ,RECVBL_COMP_INT                     --应收复息
    ,RECVBL_INT_SUB                      --应收贴息
    ,RECVBL_FINE                         --应收罚息
    ,RECVBL_OVER_INT                     --应收欠息
    ,COLL_OVER_INT                       --催收欠息
    ,TENOR                               --剩余期限
    ,LOAN_USEAGE_SUB_CL                  --贷款用途细类
    ,CUST_CHAR                           --客户性质
    ,OUT_ACCT_FLOW_NUM                   --出账流水号
    ,INDTYPE                             --联合网贷客户性质
    ,ICMS_CUST_ID                        --信贷客户编号
    ,HXB_ACPT_FLG                        --我行承兑标识
    ,BILL_SUB_INTRV_ID                   --子票据区间编号
    ,INTNAL_CARR_FLG                     --内部结转标志
    ,AD_CSH_FLG                          --过路垫款标志
    ,LC_BENEFC                           --信用证受益人
    ,FIX_INT_RAT_FLG                     --固定利率标志
    ,LC_ISSUER                           --信用证开证人
    ,BASE_RAT_IMAS                       --基准利率IMAS    --ADD BY LIP 20230810
    ,ABS_FLG                             --资产证券化标志    add by hulj20230901
    ,ASSET_TRAN_FLG                      --资产转让标志      add by hulj20230901
    ,CRED_RHT_TURN_FLG                   --债权直转标志      ADD BY HULJ20230914
    ,LOAN_TYPE_CD                        --借据类型代码      ADD BY HULJ20230914
    ,INIT_DISTR_AMT                      --原始放款金额      ADD BY LIP 20230925
    ,INIT_DISTR_DT                       --原始放款日期      ADD BY LIP 20230925
    ,INIT_TOT_PERDS                      --原始总期数        ADD BY LIP 20230925
    ,INIT_CURR_PRD                       --原始当前期数      ADD BY LIP 20230925
    ,REGROUP_LOAN_FLG                    --重组贷款标志      add by hulj 20231228
    ,REGROUP_LOAN_TYPE_CD                --重组贷款类型代码  add by hulj 20231228
    ,CNTPTY_CUST_ID                      --交易对手客户编号  ADD BY LYH 20240204
    ,RENEW_FLG_WDQ                       --展期未到期标志    add by lwb 20240408
    ,HAPP_WAY_CD                         --发生方式代码      ADD BY YJY 20241010
    ,PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志      add by yjy 20240507
    ,PAYOFF_DT                           --结清日期          ADD BY YJY 20241022
    ,SUIT_FEE_BAL                        --诉讼费余额        ADD BY YJY 20241217
    ,BILL_NUM                            --票据编码          ADD BY YJY 20250410
    ,GREEN_CRDT_CUST_FLG                 --绿色信贷客户标志  ADD BY YJY 20250508
    ,GREEN_CRDT_CLS_CD                   --绿色信贷分类_旧版代码 ADD BY YJY 20250508
    ,GREEN_CRDT_CLS_NEW                  --绿色信贷分类_新版代码 ADD BY YJY 20250508
    ,ISWHITE_FLG                         --白户标志              ADD BY LAL 20250904
    ,YBT_FLG                             --一表通口径标识        ADD BY PSF 20250916
    ,ACCT_MODIF_CATE_CD                  --账户变更类别代码      ADD BY LYH 20260127
    ,SFJWBGDK                            --是否境外并购贷款  ADD BY YJY 20260312
    ,BGDKLX                              --并购贷款类型  ADD BY YJY 20260312
    ,SFTYJRCBQY                          --是否退役军人创办企业  ADD BY YJY 20260312
    ,ACTL_AMT                            --实付金额 ADD BY YJY 20260324
    )
    WITH AGT_LOAN_CONT_RELA_TAB_INFO_H AS (
  SELECT TA.CONT_ID
         ,LISTAGG(DISTINCT TA.OBJ_ID, ';') WITHIN GROUP(ORDER BY OBJ_ID) OBJ_ID
    FROM RRP_MDL.O_IML_AGT_LOAN_CONT_RELA_TAB_INFO_H TA  --贷款合同关联表信息历史 --MOD BY LIP 20240807
   WHERE TA.OBJ_TYPE_NAME = 'BusinessDuebill'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY TA.CONT_ID),
  LOAN_REBUILD AS ( --ADD BY LIP 20260309
  SELECT A.CUSTOMERID AS CUST_ID,COUNT(A.SERIALNO) AS NUM
    FROM RRP_MDL.O_IOL_ICMS_LOAN_REBUILD A
    LEFT JOIN RRP_MDL.O_IOL_ICMS_LOAN_REBUILD_RELATIVE B
      ON B.SERIALNO = A.SERIALNO
     AND B.OBJECTTYPE = 'RestoolDuebill' --对公
   WHERE A.APPROVESTATUS IN ('Finished')
   GROUP BY A.CUSTOMERID)
  SELECT T.DATA_DT                            --数据日期
        ,T.LGL_REP_ID                         --法人编号
        ,T.ACC_ID                             --账户编号
        ,T.RCPT_ID                            --借据编号
        ,T.THIRD_RCPT_ID                      --内部借据号 ADD BY YJY 20250521
        ,T.CONT_ID                            --合同编号
        ,T.BILL_NO                            --票据号码
        ,T.COOP_AGRT_ID                       --合作协议编号
        ,TRIM(T.CUST_ID) AS CUST_ID           --客户编号
        ,T.ORG_ID                             --机构编号
        ,T.SUBJ_ID                            --科目编号
        ,T.LOAN_STD_PROD_ID                   --贷款标准产品编号
        ,T.LOAN_STD_PROD_NM                   --贷款标准产品名称
        ,T.LOAN_PROD_ID                       --贷款产品编号
        ,T.LOAN_PROD_NM                       --贷款产品名称
        ,T.LOAN_BIZ_TYP                       --贷款业务类型
        ,T.CUR                                --币种
        ,T.LOAN_AMT                           --借款金额
        ,T.LOAN_BAL                           --贷款余额
        ,T.INT_ADJ                            --利息调整
        ,T.FAIR_VAL_CHG                       --公允价值变动
        ,T.OVD_PRIN_BAL                       --逾期本金余额
        ,T.IN_INT_OVD_BAL                     --表内欠息余额
        ,T.OUT_INT_OVD_BAL                    --表外欠息余额
        ,T.LOAN_ACT_DSTR_DT                   --贷款实际发放日期
        ,T.LOAN_ORIG_EXP_DT                   --贷款原始到期日期
        ,T.LOAN_ACT_EXP_DT                    --贷款实际到期日期
        --,T.ACT_END_DT                         --实际终止日期
        ,CASE WHEN TB.RCPT_ID IS NOT NULL THEN TB.CNL_ACC_DT
              --MOD BY LIP 20260213 当实际终止日期大于跑批日期时，默认为99991231
              WHEN NVL(TRIM(T.ACT_END_DT),'29991231') IN ('00010101','20991231','29991231') THEN '99991231'
              WHEN NVL(TRIM(T.ACT_END_DT),'99991231') > V_P_DATE THEN '99991231'
              ELSE T.ACT_END_DT
          END                                 AS ACT_END_DT   --实际终止日期  --MOD BY LIP 20241122 更新票据贴现和转贴现的实际终止日期
        ,T.LAST_REPY_DT                       --上次还款日期
        ,T.LAST_REPY_AMT                      --上次还款金额
        ,T.VAL_DT                             --起息日期
        ,T.OPEN_ACC_DT                        --开户日期
        --,T.CNL_ACC_DT                         --销户日期
        ,CASE WHEN TB.RCPT_ID IS NOT NULL THEN TB.CNL_ACC_DT
              --MOD BY LIP 20260213 当销户日期大于跑批日期时，默认为99991231
              WHEN NVL(TRIM(T.CNL_ACC_DT),'29991231') IN ('00010101','20991231','29991231') THEN '99991231'
              WHEN NVL(TRIM(T.CNL_ACC_DT),'99991231') > V_P_DATE THEN '99991231'
              ELSE T.CNL_ACC_DT
          END                                 AS CNL_ACC_DT   --销户日期 --MOD BY LIP 20241122 更新票据贴现和转贴现的结清日期
        ,T.PRIN_OVD_DT                        --本金逾期日期
        ,T.INT_OVD_DT                         --利息逾期日期
        ,T.OVD_DAYS                           --逾期天数
        ,T.OVD_TYP                            --逾期类型
        ,TRIM(REPLACE(REPLACE(T.LOAN_USEAGE,CHR(10),''),CHR(13),''))  AS LOAN_USEAGE    --贷款用途
        ,T.LVL5_CL                            --五级分类
        ,T.GUA_MODE                           --担保方式
        ,T.LOAN_DIR_RGN                       --贷款投向地区
        ,T.LOAN_DIR_IDY                       --贷款投向行业
        ,T.SYN_LOAN_FLG                       --银团贷款标志
        ,T.PROJ_LOAN_FLG                      --项目贷款标志
        ,T.IDY_STRU_ADJ_TYP                   --产业结构调整类型
        ,T.IDY_TRNST_UPG_FLG                  --工业转型升级标志
        ,T.STRTG_EMER_IDY_TYP                 --战略新兴产业类型
        ,T.BANK_TAX_COOP_LOAN_FLG             --银税合作贷款标志
        ,T.AGR_REL_LOAN_FLG                   --涉农贷款标志
        ,T.RL_EST_LOAN_FLG                    --房地产贷款标志
        ,T.IALL_LOAN_FLG                      --投贷联动贷款标志
        ,T.OV_SEA_MRG_LOAN_FLG                --境外并购贷款标志
        ,T.GRN_LOAN_USEAGE_CL                 --绿色贷款用途分类
        ,T.ENT_GUA_LOAN_TYP                   --创业担保贷款类型
        ,T.CAMPUS_CNSMP_LOAN_FLG              --校园消费贷款标志
        ,T.LCL_GOVFINPLTF_LOAN_FLG            --地方政府融资平台贷款标志
        ,T.LAND_THIRDPARTY_LOAN_TYP           --将承包土地的经营权抵押给第三方的担保贷款类型
        ,T.FARMER_THIRDPARTY_LOAN_TYP         --将农民住房财产权抵押给第三方的担保贷款类型
        ,T.POV_ALLE_REC_FLG                   --未脱贫建档立卡户贷款标志
        ,T.LOAN_HDL_CHAN                      --贷款办理渠道
        ,T.NET_LOAN_FLG                       --互联网贷款标志
        ,T.NET_LOAN_PROD_TYP                  --网贷产品类别
        ,T.CR_CRD_BIZ_OD_TYP                  --类信用卡业务透支类型
        ,T.REPY_MODE                          --还款方式
        --,T.LOAN_FRM                           --贷款形式
        ,CASE WHEN TC.CUST_ID IS NOT NULL THEN '04'
              ELSE T.LOAN_FRM
          END AS LOAN_FRM                     --贷款形式 --MOD BY LIP 20260309
        ,T.RCMM_LOAN_FLG                      --重组贷款标识
        ,T.ADJ_BAD_FLG                        --下调为不良标志
        ,T.ALDY_RCMM_FLG                      --曾重组标志
        ,T.CTON_PRD_LOAN_FLG                  --缩期贷款标志
        ,T.CASH_TRF_FLG                       --现转标志
        ,T.FST_LOAN_FLG                       --首贷户贷款标志
        ,T.FIRST_LOAN_FLG                     --首次贷款标志
        ,T.PBOC_GRN_LOAN_FLG                  --PBOC绿色贷款标志
        --MOD BY LIP 20230802 调整零售贷款的绿色贷款标志
        ,CASE WHEN T.DATA_SRC = '零售贷款' AND SUBSTR(T.LOAN_BIZ_TYP,1,4) IN ('0101','0103','0104') --取消费贷款
               AND T.GRN_LOAN_USEAGE_CL IN ('40','50','60') --目前只有个人消费融资
              THEN 'Y'
              ELSE T.CBRC_GRN_LOAN_FLG
          END                                  AS CBRC_GRN_LOAN_FLG --CBRC绿色贷款标志
        ,T.CNSMP_SCN_LOAN_FLG                 --消费场景贷款标志
        ,T.LOAN_FINC_SPT_MODE                 --贷款财政扶持方式
        ,T.ACURT_POV_ALLE_LOAN_FLG            --精准扶贫贷款标志
        ,T.RATE_RE_PRC_DT                     --利率重新定价日期
        ,T.RATE_FLT_FREQ                      --利率浮动频率
        ,T.RATE_TYP                           --利率类型
        ,T.AST_SCRTZ_PROD_ID                  --资产证券化产品编号
        ,T.EXEC_RATE                          --执行利率
        ,T.BASE_RATE                          --基准利率
        ,T.CNTR_GUA_LOAN_FLG                  --反担保贷款标志
        ,T.RATE_FLT_VAL                       --利率浮动值
        ,T.PRC_BASE_TYP                       --定价基准类型
        ,T.TOT_PRD_NUM                        --总期数
        ,T.CURR_PRD                           --当前期数
        ,T.CUM_DEBT_PRD_NUM                   --累计欠款期数
        ,T.CNU_DEBT_PRD_NUM                   --连续欠款期数
        ,T.EXTN_CNT                           --展期次数
        ,T.DSBR_MODE                          --放款方式
        ,T.INT_CALC_MODE                      --计息方式
        ,T.MRGN_PCT                           --保证金比例
        ,T.MRGN_CUR                           --保证金币种
        ,T.MRGN                               --保证金
        ,TRIM(T.MRGN_ACC)                     --保证金账号
        ,TRIM(T.LOAN_OFR_NO)                  --信贷员工号
        ,T.ACCRD_INT                          --应计利息
        ,T.PRO_IMPT                           --减值准备
        ,T.COM_PRO                            --一般准备
        ,T.SPCL_PRO                           --专项准备
        ,T.ESP_PRO                            --特别准备
        ,T.SPCL_LOAN_FLG                      --专项贷款标志
        --MOD BY 20230319 增加原借据号的取数来源（借新还旧的上笔借据号）
        ,CASE WHEN TRIM(T.ORIG_RCPT_NO) IS NOT NULL
              THEN TRIM(T.ORIG_RCPT_NO)
              WHEN TRIM(TA.OBJ_ID) IS NOT NULL
              THEN TRIM(TA.OBJ_ID)
          END                                 AS ORIG_RCPT_NO  --原借据号
        ,T.FND_PCT                            --出资比例
        ,T.ETR_ACC                            --入账账号
        ,T.ETR_ACC_NM                         --入账账号户名
        ,T.LOAN_ETR_ACC_OPEN_BANK_NM          --贷款入账账号开户行名称
        ,T.REPY_ACC                           --还款账号
        ,T.LOAN_REPY_ACC_OPEN_BANK_NM         --贷款还款账号开户行名称
        /*,T.RCPT_STAT                          --借据状态
        ,T.ACC_STAT                           --账户状态*/
        --MOD BY LIP 20251111 更新有结清日期的票据数据的状态
        --,CASE WHEN TB.RCPT_ID IS NOT NULL AND TB.CNL_ACC_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        --MODIFY BY XIEZY 20251121 格式不一致对比导致报错，修改为一致格式
        ,CASE WHEN TB.RCPT_ID IS NOT NULL AND TO_DATE(TB.CNL_ACC_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN 'C01' --结清
              WHEN T.LOAN_STD_PROD_ID IN ('202010200010','202010200011') AND T.LOAN_BAL = 0
                   AND T.CNL_ACC_DT = V_P_DATE --MOD BY LIP 20260415 分期乐的账户状态是从合同表取的，借据销户后一天合同状态才变化
              THEN 'C01' --结清
              ELSE T.RCPT_STAT
          END                                AS RCPT_STAT   --借据状态
        --,CASE WHEN TB.RCPT_ID IS NOT NULL AND TB.CNL_ACC_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
        ,CASE WHEN TB.RCPT_ID IS NOT NULL AND TO_DATE(TB.CNL_ACC_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN '02' --销户
              WHEN T.LOAN_STD_PROD_ID IN ('202010200010','202010200011') AND T.LOAN_BAL = 0
                   AND T.CNL_ACC_DT = V_P_DATE --MOD BY LIP 20260415 分期乐的账户状态是从合同表取的，借据销户后一天合同状态才变化
              THEN '02' --销户
              ELSE T.ACC_STAT
          END                                AS ACC_STAT   --账户状态
        ,T.REV_LOAN_FLG                       --循环贷贷款标志
        ,T.REL_PSN_GUA_LOAN_FLG               --关系人保证贷款标志
        ,T.BEAR_OR_RED_AMT                    --承担或减免的信贷费用金额
        ,T.BIO_LOAN_FLG                       --境内外标志
        ,T.DEPT_LINE                          --部门条线
        ,T.DATA_SRC                           --数据来源
        ,T.LMT_CONT_ID                        --额度合同编号
        ,T.GXH_PAY_TYPE                       --还款方式
        ,T.GXH_PAY_FREQ                       --还款频率
        ,T.ASSET_TRAN_DT                      --资产转让日期
        ,CASE WHEN TB.RCPT_ID IS NOT NULL
               AND NVL(T.LOAN_BAL,0) + NVL(T.FAIR_VAL_CHG,0) - NVL(T.INT_ADJ,0) = 0
               AND TB.CNL_ACC_DT < TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
              THEN 'N'
              ELSE T.EAST_FLG
          END                                 AS EAST_FLG   --EAST口径标识 --MOD BY LIP 20241122
        ,T.LOAN_DIR_BIO_FLG                   --贷款投向境内外标识
        ,T.OVD_INT_BAL                        --逾期利息金额
        ,T.LOAN_CRDT_LMT_TOT                  --单户授信额度
        ,T.REFAC_FLG                          --支小再贷款标识
        ,T.BILL_ACT_AMT                       --贴现、转贴现实付金额
        ,T.LOAN_MODAL_CD                      --贷款形态代码
        ,T.OPER_ORG_ID                        --经办机构编号 ADD BY HULJ 20221123
        ,T.OPER_TELLER_ID                     --经办柜员编号 ADD BY HULJ 20221123
        ,T.LOAN_ACT_FIRST_DT                  --本行首贷日期 ADD BY HULJ 20221123
        ,T.RENEW_EXP_DAY                      --展期到期日期 ADD BY HULJ 20221123
        ,T.FIR_LON_DT                         --征信首贷日期 ADD BY HULJ 20221123
        ,T.LOAN_MGR_ID                        --借据主办客户经理号 ADD BY HULJ 20221123
        ,T.LOAN_TELLER_ID                     --借据主办柜员号 ADD BY HULJ 20221123
        ,T.LOAN_MGR_NAME                      --借据主办客户经理名称 ADD BY HULJ 20221123
        ,T.LOAN_MGR_BELONG_ORG_ID             --借据主办客户经理所属机构 ADD BY HULJ 20221123
        ,T.CNCL_DT                            --核销日期
        ,T.FIXED_INT_MARK                     --利率是否固定（与利率类型不一致）
        ,T.DISCNT_CUST_ID                     --直贴人客户号
        ,T.SYS_IN_FLG
        ,T.IN_BS_INT                          --表内利息
        ,T.OFF_BS_INT                         --表外利息
        ,T.HOLD_DAYS                          --持票天数
        ,T.DISTR_AMT                          --放款金额
        ,T.DISTR_DT                           --放款日期
        ,T.CTR_NT_ID                          --成交单编号
        ,T.RECVBL_PNLT                        --应收罚息
        ,T.COLL_PNLT                          --催收罚息
        ,T.RECVBL_COMP_INT                    --应收复息
        ,T.RECVBL_INT_SUB                     --应收贴息
        ,T.RECVBL_FINE                        --应收罚息
        ,T.RECVBL_OVER_INT                    --应收欠息
        ,T.COLL_OVER_INT                      --催收欠息
        ,T.TENOR                              --剩余期限
        ,T.LOAN_USEAGE_SUB_CL                 --贷款用途细类
        ,T.CUST_CHAR                          --客户性质
        ,T.OUT_ACCT_FLOW_NUM                  --出账流水号
        ,T.INDTYPE                            --联合网贷客户性质
        ,T.ICMS_CUST_ID                       --信贷客户编号
        ,T.HXB_ACPT_FLG                       --我行承兑标识
        ,T.BILL_SUB_INTRV_ID                  --子票据区间编号
        ,T.INTNAL_CARR_FLG                    --内部结转标志
        --ADD BY LIP 20230615 将 当日放款，当日结清的银承垫款 标记为过路垫款
        ,CASE WHEN T.LOAN_STD_PROD_ID = '203040100001' AND T.LOAN_ACT_DSTR_DT = T.CNL_ACC_DT THEN '1'
              --MOD BY 20250514 当日放款、当日结清/核销的贴现垫款标记为过路垫款
              WHEN T.LOAN_STD_PROD_ID = '203040400001' AND T.LOAN_ACT_DSTR_DT = T.CNL_ACC_DT THEN '1'
              WHEN T.LOAN_STD_PROD_ID = '203040400001' AND T.LOAN_ACT_DSTR_DT = T.CNCL_DT THEN '1'
              ELSE '0'
          END                                 AS AD_CSH_FLG      --过路垫款标志
        ,T.LC_BENEFC                           --信用证受益人
        ,T.FIX_INT_RAT_FLG                     --固定利率标志
        ,T.LC_ISSUER                           --信用证开证人
        ,T.BASE_RAT_IMAS                       --基准利率IMAS     --ADD BY LIP 20230810
        ,T.ABS_FLG                             --资产证券化标志     ADD BY HULJ20230901
        ,T.ASSET_TRAN_FLG                      --资产转让标志       ADD BY HULJ20230901
        ,T.CRED_RHT_TURN_FLG                   --债权直转标志       ADD BY HULJ20230914
        ,T.LOAN_TYPE_CD                        --借据类型代码       ADD BY HULJ20230914
        ,NVL(T.INIT_DISTR_AMT,T.DISTR_AMT)    AS INIT_DISTR_AMT --原始放款金额    ADD BY LIP 20230925
        ,NVL(T.INIT_DISTR_DT,T.DISTR_DT)      AS INIT_DISTR_DT  --原始放款日期    ADD BY LIP 20230925
        ,NVL(T.INIT_TOT_PERDS,T.TOT_PRD_NUM)  AS INIT_TOT_PERDS --原始总期数      ADD BY LIP 20230925
        ,NVL(T.INIT_CURR_PRD,T.CURR_PRD)      AS INIT_CURR_PRD  --原始当前期数    ADD BY LIP 20230925
        ,T.REGROUP_LOAN_FLG                    --重组贷款标志       ADD BY HULJ 20231228
        ,T.REGROUP_LOAN_TYPE_CD                --重组贷款类型代码   ADD BY HULJ 20231228
        ,T.CNTPTY_CUST_ID                      --交易对手客户编号 --ADD BY LYH 20240204
        ,T.RENEW_FLG_WDQ                       --展期未到期标志   --add by lwb 20240408
        ,T.HAPP_WAY_CD                         --发生方式代码       ADD BY YJY 20241010
        ,T.PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志     --add by yjy 20240507
        ,T.PAYOFF_DT                           --结清日期         --ADD BY YJY 20241022
        ,T.SUIT_FEE_BAL                        --诉讼费余额       --ADD BY YJY 20241217
        ,T.BILL_NUM                            --票据编码         --ADD BY YJY 20250410
        ,T.GREEN_CRDT_CUST_FLG                 --绿色信贷客户标志  --ADD BY YJY 20250508
        ,T.GREEN_CRDT_CLS_CD                   --绿色信贷分类_旧版代码 --ADD BY YJY 20250508
        ,T.GREEN_CRDT_CLS_NEW                  --绿色信贷分类_新版代码 --ADD BY YJY 20250508
        ,T.ISWHITE_FLG                         --白户标志     --ADD BY LAL 20250904
        ,CASE /*WHEN (T.RCPT_STAT = 'C01' OR T.RCPT_STAT = 'C0201' OR T.RCPT_STAT LIKE 'C0202%')
                   AND T.LOAN_BAL = 0 AND T.PAYOFF_DT = '29991231'
              THEN 'N'*/ --MOD BY ZLY 20251124
              WHEN TB.RCPT_ID IS NOT NULL
               AND NVL(T.LOAN_BAL,0) + NVL(T.FAIR_VAL_CHG,0) - NVL(T.INT_ADJ,0) = 0
               AND TB.CNL_ACC_DT < TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
              THEN 'N' 
              WHEN T.RCPT_ID = '20130927111001' THEN 'N' --MOD BY YJY 20251225 该借据已历史核销
              ELSE T.YBT_FLG  
         END                   AS YBT_FLG      --一表通口径标识  --MOD BY ZLY 20251105 对于贷款余额为0且结清日期为29991231置N
        ,T.ACCT_MODIF_CATE_CD                  --账户变更类别代码 --ADD BY LYH 20260127
        ,T.SFJWBGDK                   AS SFJWBGDK                    --是否境外并购贷款  ADD BY YJY 20260312
        ,T.BGDKLX                     AS BGDKLX                      --并购贷款类型  ADD BY YJY 20260312
        ,T.SFTYJRCBQY                 AS SFTYJRCBQY                  --是否退役军人创办企业  ADD BY YJY 20260312
        ,T.ACTL_AMT                   AS ACTL_AMT                    --实付金额 ADD BY YJY 20260324
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO_TMP T
    --MOD BY 20240319 取借新还旧的上笔借据号
    /*LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_RELA_TAB_INFO_H TA --贷款合同关联表信息历史
      ON TA.CONT_ID = T.CONT_ID
     AND TA.OBJ_TYPE_NAME = 'BusinessDuebill'
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/
    LEFT JOIN AGT_LOAN_CONT_RELA_TAB_INFO_H TA --贷款合同关联表信息历史 --MOD BY LIP 20240807
      ON TA.CONT_ID = T.CONT_ID
    LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO_TEMP07 TB --ADD BY LIP 20241122
      ON TB.RCPT_ID = T.RCPT_ID
    LEFT JOIN LOAN_REBUILD TC  --MOD BY LIP 20260309
      ON TC.CUST_ID = T.CUST_ID
   WHERE T.RCPT_ID IS NOT NULL
     AND T.LOAN_ACT_DSTR_DT <= V_P_DATE; --剔除未入系统的银承垫款

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG   := '数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_IN_DUBILL_INFO;
/

