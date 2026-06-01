/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_FKD_IQP_LOAN_PRIOR_ret1
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
                       FROM ICMS_FKD_IQP_LOAN_PRIOR_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_FKD_IQP_LOAN_PRIOR');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_FKD_IQP_LOAN_PRIOR drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_FKD_IQP_LOAN_PRIOR add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_FKD_IQP_LOAN_PRIOR(
            serialno -- 业务流水号
            ,iscollectcredit -- 征信查询情况
            ,originalloan -- 是否有原贷款
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,projectname -- 小区名称
            ,isbankorg -- 是否银行机构
            ,approvestatus -- 初审审批状态
            ,inputid -- 推荐人
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,lot -- 份额
            ,nationality -- 国籍
            ,prdname -- 产品名称
            ,enterpriseyearincome -- 经营主体年销售收
            ,customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
            ,individexpdt -- 证件到期日
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,appchannel -- 接入渠道
            ,sysid -- 系统来源
            ,deviceamount -- 设备数量（定型机）
            ,certtype -- 主借人证件类型
            ,autoscore -- 评分分值
            ,isotherbankmtg -- 是否他行在押房产
            ,qryopertp -- 查询操作申请类型
            ,isgetcuscode -- 是否开户成功
            ,comname -- 地推公司名称
            ,msflag -- 庙算是否通过
            ,indivocc -- 职业
            ,onbranchbank -- 所在分行
            ,relationphone -- 直系亲属联系电话
            ,taxapprovestatus -- 涉税审批状态
            ,isbankrel -- 是否我行关联人
            ,seqid -- 请求流水（用于庙算接口查询）
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,accountbank -- 绑定银行卡开户行
            ,accountname -- 绑定银行卡户名
            ,authostrdate -- 授权开始时间
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,recacctbankname -- 开户行(经销商)
            ,indivrsdaddr -- 居住地址
            ,ischeckinspect -- 联网核查状态
            ,phone -- 手机号
            ,informflag -- 初审通知成功与否
            ,failreason -- 拒绝原因
            ,otherdirection -- 其他原房产贷款类型说明
            ,cityname -- 所在城市
            ,taxpayeridentino -- 纳税人识别号
            ,monincome -- 税后月收入
            ,biometrics -- 生物识别技术
            ,custname -- 客户姓名
            ,cltrtyp -- 押品类型
            ,mainbusiness -- 主营业务
            ,cltrname -- 押品名称
            ,whitecertcode -- 白名单客户证件号码
            ,limitloanterm -- 额度合同申请期限
            ,isonloanbank -- 在途贷款银行
            ,taxbureauserno -- 税局授权流水
            ,preloanterm -- 兴车贷-贷款期限
            ,risklevel -- 风险等级
            ,warninginfo -- 预警信息
            ,whitecusid -- 白名单客户号
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,repayway -- 还款方式
            ,accumulfundmon -- 公积金连续缴存月数
            ,roomprice -- 评估价值
            ,applyno -- 信贷申请流水号
            ,inputtime -- 初审申请时间
            ,indivsex -- 性别
            ,cuttomgroupname -- 客群分类名称
            ,devicetotalprice -- 企业设备资产总值
            ,finabrid -- 账务机构
            ,migtflag -- 
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,channelno -- 渠道号
            ,comno -- 地推公司编号
            ,recacct -- 收款账户(经销商)
            ,accountnumber -- 绑定银行卡账号
            ,cfmseqnum -- 智贷押品确认流水号
            ,ownerflag -- 借款人是否实控人
            ,fourelementsverificationresult -- 绑定银行卡四要素验证结果
            ,urgentcontactphone -- 紧急联系人电话
            ,urgentcontactname -- 紧急联系人姓名
            ,ishouse -- 是否有房
            ,prdcode -- 产品编号
            ,cusid -- 客户号
            ,roomsize -- 房屋面积
            ,taxrelatedtype -- 涉税类型
            ,propertytype -- 房产类型-STD_FKD_FCLX
            ,istaxrela -- 是否跑涉税风控
            ,relationname -- 直系亲属姓名
            ,inputdate -- 初审申请日期
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,ctrlbranch -- 所属分行
            ,inputbrid -- 管理机构
            ,netvalue -- 净值
            ,invtstkperc -- 借款人持股比例
            ,coopno -- 合作方客户经理工号
            ,oloaniscircle -- 原贷款是否循环
            ,principalamt -- 本金
            ,purpors -- 贷款用途
            ,certno -- 主借人证件编号
            ,isemoji -- 是否有影像文件
            ,orghouseloantype -- 原房产贷款类型
            ,authotime -- 授权时间
            ,creditamt -- 授信金额
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,detailaddr -- 房产地址
            ,areacode -- 区域编号
            ,grtduedate -- 押品到期日
            ,socialmon -- 社保连续缴存月数
            ,authoenddate -- 授权结束时间
            ,monthlyrepay -- 月还款金额
            ,whitecerttype -- 白名单客户证件类型
            ,authotype -- 授权方式
            ,orgmtgbank -- 原抵押银行
            ,loanamt -- 客户贷款金额
            ,obankloanamt -- 原银行房贷贷款金额
            ,indivoccremarks -- 职业备注信息
            ,ctrlorg -- 所属机构
            ,apprendtime -- 审批结束时间
            ,cityareacode -- 城市编码
            ,mscreditamt -- 庙算初审额度
            ,oloansurterm -- 原贷款剩余期限
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,pauperroomprice -- 世联下户评估价值
            ,bkprice -- 贝壳网房产评估价值
            ,certidstartdate -- 证件起始日
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,cuscreditscorelevel -- 
            ,matchpurchhousecondition -- 
            ,housetxnprice -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,identityexpire -- 
            ,enttype -- 
            ,enterprisename -- 
            ,entidttp -- 
            ,entidtno -- 
            ,entaddress -- 
            ,enttermduedate -- 
            ,cobsratio -- 
            ,updatedate -- 
            ,istaxsuccessgs -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,businessserialno -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 业务流水号
            ,iscollectcredit -- 征信查询情况
            ,originalloan -- 是否有原贷款
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,projectname -- 小区名称
            ,isbankorg -- 是否银行机构
            ,approvestatus -- 初审审批状态
            ,inputid -- 推荐人
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,lot -- 份额
            ,nationality -- 国籍
            ,prdname -- 产品名称
            ,enterpriseyearincome -- 经营主体年销售收
            ,customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
            ,individexpdt -- 证件到期日
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,appchannel -- 接入渠道
            ,sysid -- 系统来源
            ,deviceamount -- 设备数量（定型机）
            ,certtype -- 主借人证件类型
            ,autoscore -- 评分分值
            ,isotherbankmtg -- 是否他行在押房产
            ,qryopertp -- 查询操作申请类型
            ,isgetcuscode -- 是否开户成功
            ,comname -- 地推公司名称
            ,msflag -- 庙算是否通过
            ,indivocc -- 职业
            ,onbranchbank -- 所在分行
            ,relationphone -- 直系亲属联系电话
            ,taxapprovestatus -- 涉税审批状态
            ,isbankrel -- 是否我行关联人
            ,seqid -- 请求流水（用于庙算接口查询）
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,accountbank -- 绑定银行卡开户行
            ,accountname -- 绑定银行卡户名
            ,authostrdate -- 授权开始时间
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,recacctbankname -- 开户行(经销商)
            ,indivrsdaddr -- 居住地址
            ,ischeckinspect -- 联网核查状态
            ,phone -- 手机号
            ,informflag -- 初审通知成功与否
            ,failreason -- 拒绝原因
            ,otherdirection -- 其他原房产贷款类型说明
            ,cityname -- 所在城市
            ,taxpayeridentino -- 纳税人识别号
            ,monincome -- 税后月收入
            ,biometrics -- 生物识别技术
            ,custname -- 客户姓名
            ,cltrtyp -- 押品类型
            ,mainbusiness -- 主营业务
            ,cltrname -- 押品名称
            ,whitecertcode -- 白名单客户证件号码
            ,limitloanterm -- 额度合同申请期限
            ,isonloanbank -- 在途贷款银行
            ,taxbureauserno -- 税局授权流水
            ,preloanterm -- 兴车贷-贷款期限
            ,risklevel -- 风险等级
            ,warninginfo -- 预警信息
            ,whitecusid -- 白名单客户号
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,repayway -- 还款方式
            ,accumulfundmon -- 公积金连续缴存月数
            ,roomprice -- 评估价值
            ,applyno -- 信贷申请流水号
            ,inputtime -- 初审申请时间
            ,indivsex -- 性别
            ,cuttomgroupname -- 客群分类名称
            ,devicetotalprice -- 企业设备资产总值
            ,finabrid -- 账务机构
            ,migtflag -- 
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,channelno -- 渠道号
            ,comno -- 地推公司编号
            ,recacct -- 收款账户(经销商)
            ,accountnumber -- 绑定银行卡账号
            ,cfmseqnum -- 智贷押品确认流水号
            ,ownerflag -- 借款人是否实控人
            ,fourelementsverificationresult -- 绑定银行卡四要素验证结果
            ,urgentcontactphone -- 紧急联系人电话
            ,urgentcontactname -- 紧急联系人姓名
            ,ishouse -- 是否有房
            ,prdcode -- 产品编号
            ,cusid -- 客户号
            ,roomsize -- 房屋面积
            ,taxrelatedtype -- 涉税类型
            ,propertytype -- 房产类型-STD_FKD_FCLX
            ,istaxrela -- 是否跑涉税风控
            ,relationname -- 直系亲属姓名
            ,inputdate -- 初审申请日期
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,ctrlbranch -- 所属分行
            ,inputbrid -- 管理机构
            ,netvalue -- 净值
            ,invtstkperc -- 借款人持股比例
            ,coopno -- 合作方客户经理工号
            ,oloaniscircle -- 原贷款是否循环
            ,principalamt -- 本金
            ,purpors -- 贷款用途
            ,certno -- 主借人证件编号
            ,isemoji -- 是否有影像文件
            ,orghouseloantype -- 原房产贷款类型
            ,authotime -- 授权时间
            ,creditamt -- 授信金额
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,detailaddr -- 房产地址
            ,areacode -- 区域编号
            ,grtduedate -- 押品到期日
            ,socialmon -- 社保连续缴存月数
            ,authoenddate -- 授权结束时间
            ,monthlyrepay -- 月还款金额
            ,whitecerttype -- 白名单客户证件类型
            ,authotype -- 授权方式
            ,orgmtgbank -- 原抵押银行
            ,loanamt -- 客户贷款金额
            ,obankloanamt -- 原银行房贷贷款金额
            ,indivoccremarks -- 职业备注信息
            ,ctrlorg -- 所属机构
            ,apprendtime -- 审批结束时间
            ,cityareacode -- 城市编码
            ,mscreditamt -- 庙算初审额度
            ,oloansurterm -- 原贷款剩余期限
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,pauperroomprice -- 世联下户评估价值
            ,bkprice -- 贝壳网房产评估价值
            ,certidstartdate -- 证件起始日
            ,' ' AS iscrossregionrun -- 
            ,' ' AS wisdomloanmode -- 
            ,' ' AS cuscreditscorelevel -- 
            ,' ' AS matchpurchhousecondition -- 
            ,0 AS housetxnprice -- 
            ,' ' AS isaddedvalue -- 
            ,0 AS addedvalue -- 
            ,0 AS carinvoice -- 
            ,' ' AS isnewcoborrower -- 
            ,' ' AS villatype -- 
            ,' ' AS housetypelocation -- 
            ,' ' AS rowno -- 
            ,0 AS gardenarea -- 
            ,0 AS freearea -- 
            ,to_date('00010101','yyyymmdd') AS identityexpire -- 
            ,' ' AS enttype -- 
            ,' ' AS enterprisename -- 
            ,' ' AS entidttp -- 
            ,' ' AS entidtno -- 
            ,' ' AS entaddress -- 
            ,to_date('00010101','yyyymmdd') AS enttermduedate -- 
            ,0 AS cobsratio -- 
            ,to_date('00010101','yyyymmdd') AS updatedate -- 
            ,' ' AS istaxsuccessgs -- 
            ,' ' AS ishavecar -- 
            ,' ' AS licensenumber -- 
            ,to_date('00010101','yyyymmdd') AS drivinglicensedate -- 
            ,' ' AS businessserialno -- 
            ,' ' AS resiloczonecd -- 
            ,' ' AS untloczonecd -- 
            ,' ' AS resiloczone -- 
            ,' ' AS compphone -- 
            ,' ' AS isriskcust -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_FKD_IQP_LOAN_PRIOR_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
