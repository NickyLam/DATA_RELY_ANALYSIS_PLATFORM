/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_FKD_IQP_LOAN_APP_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ICMS_FKD_IQP_LOAN_APP_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_FKD_IQP_LOAN_APP');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_FKD_IQP_LOAN_APP drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_FKD_IQP_LOAN_APP add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_FKD_IQP_LOAN_APP(
            serialno -- 业务流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,ctrlbranch -- 所属分行
            ,appchannel -- 接入渠道
            ,channelno -- 渠道号
            ,applyno -- 信贷申请流水号
            ,appadvice -- 审批意见
            ,appconclusion -- 审批结论
            ,certtype -- 主借人证件类型
            ,certno -- 主借人证件编号
            ,gender -- 性别
            ,issauthority -- 签发机关
            ,isscountry -- 签发国家
            ,issdate -- 签发日期
            ,expirydate -- 到期日期
            ,bankind -- 本行员工标志
            ,hashouseind -- 除本次抵押房产外，是否有其他住房
            ,housecount -- 房产数量
            ,paysourcen -- 还款来源
            ,partnercoownerind -- 配偶共有人标志
            ,partnerrelind -- 配偶关联人标志
            ,marriagedate -- 婚姻登记日期
            ,businesstype -- 经营类型
            ,merchantname -- 商户名称
            ,businessaddrtype -- 经营场所类型
            ,businessaddr -- 经营场所
            ,bsoptname -- 经营者
            ,actualcontroler -- 实际控制人
            ,businessscope -- 经营范围
            ,enterprisename -- 企业名称
            ,unifysocialcreditnum -- 统一社会信用编号
            ,orginstitudecode -- 组织机构代码
            ,entloanaccount -- 企业贷款卡/中征码
            ,entlegalpersonname -- 企业法人姓名
            ,entlegalpersonidno -- 企业法人身份证号
            ,borroweridentity -- 借款人身份
            ,registaddress -- 注册地址
            ,registassets -- 注册资本
            ,validitedate -- 有效期
            ,registdate -- 注册日期
            ,cptype -- 企业类型
            ,bsstartdate -- 营业起始日
            ,bsenddate -- 营业到期日
            ,practyears -- 法人从业年限
            ,licensename -- 许可证名称
            ,licenseno -- 许可证编号
            ,companyyear -- 经营年限
            ,userbusinesssum -- 客户经理意见金额
            ,userlimitterm -- 客户经理意见期限
            ,recommendtype -- 推荐类型
            ,recommendagency -- 推荐中介名称
            ,creditamt -- 授信金额
            ,inputtime -- 终审申请时间
            ,autoscore -- 评分分值
            ,iscollectcredit -- 征信查询情况
            ,informflag -- 终审通知成功与否
            ,loaninformflag -- 放款通知成功与否
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,cusid -- 客户号
            ,detailaddr -- 详细地址
            ,worknature -- 工作性质
            ,inputbrid -- 管理机构
            ,isbankrel -- 是否我行关联人
            ,phone -- 手机号
            ,apprendtime -- 审批结束时间
            ,isemoji -- 是否有影像文件
            ,inputid -- 分行客户经理号（普惠金融专用）
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
            ,seqid -- 请求流水（用于庙算接口查询）
            ,comno -- 地推公司编号
            ,comname -- 地推公司名称
            ,checkersuggest -- 下户核验意见
            ,inspsuggest -- 质检岗意见
            ,inspsum -- 质检岗建议金额
            ,insplimitterm -- 质检岗建议期限
            ,interviewsuggest -- 面谈意见
            ,ispreflag -- 是否预终审
            ,contno -- 合同编号
            ,guarantyid -- 押品编号
            ,conttype -- 合同类型（1:单笔合同2：额度合同）
            ,isonline -- 是否线上（1-是2否）
            ,domicileaddr -- 户籍所在地（户籍地址）
            ,lmtserno -- 额度合同编号
            ,originalloan -- 是否有原贷款
            ,isotherbankmtg -- 是否他行在押房产
            ,orgmtgbank -- 原抵押银行
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,isddjfloan -- 大道是否放款
            ,canceltype -- 取消类型（1取消订单，2取消放款）
            ,loaninterdt -- 同贷交互时间
            ,oloaniscircle -- 原贷款是否循环
            ,isbankorg -- 是否银行机构
            ,isonloanbank -- 在途贷款银行
            ,obankloanamt -- 原银行房贷贷款金额
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,oloansurterm -- 原贷款剩余期限
            ,enterpriseyearincome -- 企业年收入
            ,orghouseloantype -- 原房产贷款类型
            ,otherdirection -- 其他原房产贷款类型说明
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,taxbureauserno -- 税局授权流水
            ,taxrelatedtype -- 涉税类型
            ,taxpayeridentino -- 纳税人识别号
            ,employmentsituation -- 就业状况
            ,annualtaxrevenue -- 客户纳税年收入
            ,ddjfapprovestatus -- 大道审批结果
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,invtstkperc -- 借款人持股比例
            ,coboinvtstkperc -- 共借人持股比例
            ,onbranchbank -- 所在分行
            ,risklevel -- 风险等级
            ,lot -- 份额
            ,netvalue -- 净值
            ,principalamt -- 本金
            ,loanstartdate -- 贷款起始日
            ,loanenddate -- 贷款到期日
            ,warninginfo -- 预警信息
            ,loantype -- 贷款类型（STD_KD_LOAN_TYPE）
            ,lmtloanappno -- 额度合同信贷申请流水号
            ,relationname -- 直系亲属姓名
            ,relationphone -- 直系亲属联系电话
            ,urgentcontactname -- 紧急联系人姓名
            ,urgentcontactphone -- 紧急联系人电话
            ,socialmon -- 社保连续缴存月数
            ,accumulfundmon -- 公积金连续缴存月数
            ,monincome -- 税后月收入
            ,monthlyrepay -- 月还款金额
            ,ishouse -- 是否有房
            ,preloanterm -- 兴车贷-贷款期限
            ,isborrowbook -- 同贷书是否生成
            ,docoutputloca -- 同贷书地址
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,recacct -- 收款账户(经销商)
            ,recacctbankname -- 开户行(经销商)
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,loanamt -- 客户贷款金额
            ,obillno -- 原借据号
            ,ocontno -- 原合同号
            ,oloanamount -- 原借据金额
            ,oloanbalance -- 原借据余额
            ,renewalstartdate -- 续贷起始日期
            ,renewalenddate -- 续贷到期日期
            ,iswhite -- 是否白户
            ,whitecusid -- 白名单客户号
            ,whitecerttype -- 白名单客户证件类型
            ,whitecertcode -- 白名单客户证件号码
            ,mainbusiness -- 主营业务
            ,deviceamount -- 设备数量（定型机）
            ,devicetotalprice -- 企业设备资产总值
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,ownerflag -- 借款人是否实控人
            ,limitloanterm -- 额度合同申请期限
            ,ctrlorg -- 所属机构
            ,migtflag -- 
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,applyamt -- 申请金额
            ,blankcollateral -- 抵押物毛坯状态
            ,fundlegal -- 本次质押标的的资金来源是否合法合规
            ,iszdwhile -- 是否智贷白名单
            ,managerialsetupamt -- 经营机构推荐贷款额度
            ,natureland -- 土地性质
            ,naturelandexplain -- 土地性质其他说明
            ,natureregistered -- 户籍性质
            ,ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
            ,specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
            ,specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
            ,branchmanageopinion -- 分行零售信贷负责人意见
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,highestcreditorrightamt -- 
            ,cuscreditscorelevel -- 
            ,renewalmodel -- 
            ,selfemplflg -- 
            ,salapeopflg -- 
            ,bropermshrhratio -- 
            ,csldsocilccode -- 
            ,firstpayamt -- 
            ,prepapplowncnt -- 
            ,prepapplcomperrela -- 
            ,brwersixmonincome -- 
            ,brwersixmonfundpayamt -- 
            ,brwerfundmonpayamt -- 
            ,brwerfunduntpayratio -- 
            ,brwerfundindvpayratio -- 
            ,brwerretiage -- 
            ,spousixmonincome -- 
            ,spousixmonfundpayamt -- 
            ,ownhouseqty -- 
            ,locallmtpurchplcy -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,imagecheckno -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,cardaddr -- 
            ,idenblngprovcity -- 
            ,roomprice -- 
            ,yearlyrental -- 
            ,updatedate -- 
            ,creditmodel -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,atachcomm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 业务流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,ctrlbranch -- 所属分行
            ,appchannel -- 接入渠道
            ,channelno -- 渠道号
            ,applyno -- 信贷申请流水号
            ,appadvice -- 审批意见
            ,appconclusion -- 审批结论
            ,certtype -- 主借人证件类型
            ,certno -- 主借人证件编号
            ,gender -- 性别
            ,issauthority -- 签发机关
            ,isscountry -- 签发国家
            ,issdate -- 签发日期
            ,expirydate -- 到期日期
            ,bankind -- 本行员工标志
            ,hashouseind -- 除本次抵押房产外，是否有其他住房
            ,housecount -- 房产数量
            ,paysourcen -- 还款来源
            ,partnercoownerind -- 配偶共有人标志
            ,partnerrelind -- 配偶关联人标志
            ,marriagedate -- 婚姻登记日期
            ,businesstype -- 经营类型
            ,merchantname -- 商户名称
            ,businessaddrtype -- 经营场所类型
            ,businessaddr -- 经营场所
            ,bsoptname -- 经营者
            ,actualcontroler -- 实际控制人
            ,businessscope -- 经营范围
            ,enterprisename -- 企业名称
            ,unifysocialcreditnum -- 统一社会信用编号
            ,orginstitudecode -- 组织机构代码
            ,entloanaccount -- 企业贷款卡/中征码
            ,entlegalpersonname -- 企业法人姓名
            ,entlegalpersonidno -- 企业法人身份证号
            ,borroweridentity -- 借款人身份
            ,registaddress -- 注册地址
            ,registassets -- 注册资本
            ,validitedate -- 有效期
            ,registdate -- 注册日期
            ,cptype -- 企业类型
            ,bsstartdate -- 营业起始日
            ,bsenddate -- 营业到期日
            ,practyears -- 法人从业年限
            ,licensename -- 许可证名称
            ,licenseno -- 许可证编号
            ,companyyear -- 经营年限
            ,userbusinesssum -- 客户经理意见金额
            ,userlimitterm -- 客户经理意见期限
            ,recommendtype -- 推荐类型
            ,recommendagency -- 推荐中介名称
            ,creditamt -- 授信金额
            ,inputtime -- 终审申请时间
            ,autoscore -- 评分分值
            ,iscollectcredit -- 征信查询情况
            ,informflag -- 终审通知成功与否
            ,loaninformflag -- 放款通知成功与否
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,cusid -- 客户号
            ,detailaddr -- 详细地址
            ,worknature -- 工作性质
            ,inputbrid -- 管理机构
            ,isbankrel -- 是否我行关联人
            ,phone -- 手机号
            ,apprendtime -- 审批结束时间
            ,isemoji -- 是否有影像文件
            ,inputid -- 分行客户经理号（普惠金融专用）
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
            ,seqid -- 请求流水（用于庙算接口查询）
            ,comno -- 地推公司编号
            ,comname -- 地推公司名称
            ,checkersuggest -- 下户核验意见
            ,inspsuggest -- 质检岗意见
            ,inspsum -- 质检岗建议金额
            ,insplimitterm -- 质检岗建议期限
            ,interviewsuggest -- 面谈意见
            ,ispreflag -- 是否预终审
            ,contno -- 合同编号
            ,guarantyid -- 押品编号
            ,conttype -- 合同类型（1:单笔合同2：额度合同）
            ,isonline -- 是否线上（1-是2否）
            ,domicileaddr -- 户籍所在地（户籍地址）
            ,lmtserno -- 额度合同编号
            ,originalloan -- 是否有原贷款
            ,isotherbankmtg -- 是否他行在押房产
            ,orgmtgbank -- 原抵押银行
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,isddjfloan -- 大道是否放款
            ,canceltype -- 取消类型（1取消订单，2取消放款）
            ,loaninterdt -- 同贷交互时间
            ,oloaniscircle -- 原贷款是否循环
            ,isbankorg -- 是否银行机构
            ,isonloanbank -- 在途贷款银行
            ,obankloanamt -- 原银行房贷贷款金额
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,oloansurterm -- 原贷款剩余期限
            ,enterpriseyearincome -- 企业年收入
            ,orghouseloantype -- 原房产贷款类型
            ,otherdirection -- 其他原房产贷款类型说明
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,taxbureauserno -- 税局授权流水
            ,taxrelatedtype -- 涉税类型
            ,taxpayeridentino -- 纳税人识别号
            ,employmentsituation -- 就业状况
            ,annualtaxrevenue -- 客户纳税年收入
            ,ddjfapprovestatus -- 大道审批结果
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,invtstkperc -- 借款人持股比例
            ,coboinvtstkperc -- 共借人持股比例
            ,onbranchbank -- 所在分行
            ,risklevel -- 风险等级
            ,lot -- 份额
            ,netvalue -- 净值
            ,principalamt -- 本金
            ,loanstartdate -- 贷款起始日
            ,loanenddate -- 贷款到期日
            ,warninginfo -- 预警信息
            ,loantype -- 贷款类型（STD_KD_LOAN_TYPE）
            ,lmtloanappno -- 额度合同信贷申请流水号
            ,relationname -- 直系亲属姓名
            ,relationphone -- 直系亲属联系电话
            ,urgentcontactname -- 紧急联系人姓名
            ,urgentcontactphone -- 紧急联系人电话
            ,socialmon -- 社保连续缴存月数
            ,accumulfundmon -- 公积金连续缴存月数
            ,monincome -- 税后月收入
            ,monthlyrepay -- 月还款金额
            ,ishouse -- 是否有房
            ,preloanterm -- 兴车贷-贷款期限
            ,isborrowbook -- 同贷书是否生成
            ,docoutputloca -- 同贷书地址
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,recacct -- 收款账户(经销商)
            ,recacctbankname -- 开户行(经销商)
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,loanamt -- 客户贷款金额
            ,obillno -- 原借据号
            ,ocontno -- 原合同号
            ,oloanamount -- 原借据金额
            ,oloanbalance -- 原借据余额
            ,renewalstartdate -- 续贷起始日期
            ,renewalenddate -- 续贷到期日期
            ,iswhite -- 是否白户
            ,whitecusid -- 白名单客户号
            ,whitecerttype -- 白名单客户证件类型
            ,whitecertcode -- 白名单客户证件号码
            ,mainbusiness -- 主营业务
            ,deviceamount -- 设备数量（定型机）
            ,devicetotalprice -- 企业设备资产总值
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,ownerflag -- 借款人是否实控人
            ,limitloanterm -- 额度合同申请期限
            ,ctrlorg -- 所属机构
            ,migtflag -- 
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,applyamt -- 申请金额
            ,blankcollateral -- 抵押物毛坯状态
            ,fundlegal -- 本次质押标的的资金来源是否合法合规
            ,iszdwhile -- 是否智贷白名单
            ,managerialsetupamt -- 经营机构推荐贷款额度
            ,natureland -- 土地性质
            ,naturelandexplain -- 土地性质其他说明
            ,natureregistered -- 户籍性质
            ,ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
            ,specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
            ,specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
            ,branchmanageopinion -- 分行零售信贷负责人意见
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,' ' AS iscrossregionrun -- 
            ,' ' AS wisdomloanmode -- 
            ,0 AS highestcreditorrightamt -- 
            ,' ' AS cuscreditscorelevel -- 
            ,' ' AS renewalmodel -- 
            ,' ' AS selfemplflg -- 
            ,' ' AS salapeopflg -- 
            ,0 AS bropermshrhratio -- 
            ,' ' AS csldsocilccode -- 
            ,0 AS firstpayamt -- 
            ,' ' AS prepapplowncnt -- 
            ,' ' AS prepapplcomperrela -- 
            ,0 AS brwersixmonincome -- 
            ,0 AS brwersixmonfundpayamt -- 
            ,0 AS brwerfundmonpayamt -- 
            ,0 AS brwerfunduntpayratio -- 
            ,0 AS brwerfundindvpayratio -- 
            ,' ' AS brwerretiage -- 
            ,0 AS spousixmonincome -- 
            ,0 AS spousixmonfundpayamt -- 
            ,' ' AS ownhouseqty -- 
            ,' ' AS locallmtpurchplcy -- 
            ,' ' AS isaddedvalue -- 
            ,0 AS addedvalue -- 
            ,0 AS carinvoice -- 
            ,' ' AS isnewcoborrower -- 
            ,' ' AS imagecheckno -- 
            ,' ' AS villatype -- 
            ,' ' AS housetypelocation -- 
            ,' ' AS rowno -- 
            ,0 AS gardenarea -- 
            ,0 AS freearea -- 
            ,' ' AS cardaddr -- 
            ,' ' AS idenblngprovcity -- 
            ,0 AS roomprice -- 
            ,0 AS yearlyrental -- 
            ,to_date('00010101','yyyymmdd') AS updatedate -- 
            ,' ' AS creditmodel -- 
            ,' ' AS ishavecar -- 
            ,' ' AS licensenumber -- 
            ,to_date('00010101','yyyymmdd') AS drivinglicensedate -- 
            ,' ' AS resiloczonecd -- 
            ,' ' AS untloczonecd -- 
            ,' ' AS resiloczone -- 
            ,' ' AS compphone -- 
            ,' ' AS isriskcust -- 
            ,' ' AS atachcomm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_FKD_IQP_LOAN_APP_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
