/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_guaranty_contract
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icms_guaranty_contract drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_guaranty_contract add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_guaranty_contract partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,checkguarantydate  -- 核保日期
    ,checkguarantymana  -- 核保人;一）
    ,checkguarantymanb  -- 核保人;二）
    ,certtype  -- 担保人证件类型
    ,certid  -- 担保人证件号码
    ,loancardno  -- 担保人贷款卡编号
    ,guaranteeform  -- 保证担保形式
    ,inputorgid  -- 登记机构
    ,inputuserid  -- 登记人
    ,inputdate  -- 登记日期
    ,updateorgid  -- 更新机构
    ,updateuserid  -- 更新人
    ,updatedate  -- 更新日期
    ,remark  -- 备注
    ,corporgid  -- 法人机构编号
    ,authostrdate  -- 授权起始日
    ,istranguaranty  -- 是否包含反担保措施
    ,isquerycreditreport  -- 征信查询授权书编号
    ,creditauthno  -- 征信查询授权书编号
    ,industrytype  -- 国标行业分类
    ,enterprisescope  -- 企业规模
    ,ecodepartmentcode  -- 国民经济部门
    ,newregioncode  -- 注册地行政区划代码
    ,issaveowner  -- 是否直接向我行担保
    ,obligeename  -- 权利人名称
    ,obligeeid  -- 权利人客户编号
    ,iscustody  -- 是否代保管
    ,residentflag  -- 居民标志
    ,registationcode  -- 注册国家/地区代码
    ,guarantyorsum  -- 保证人净资产
    ,ypguarantorid  -- 押品系统保证人id
    ,guarantyfax  -- 保证人传真
    ,guarantyphone  -- 保证人电话
    ,guarantyaddress  -- 保证人地址
    ,isinuse  -- 添加维护标志1正常2不维护
    ,preserialno  -- 被拷贝的担保流水号
    ,creditaggreement  -- 额度协议流水号
    ,thirdcreditsum  -- 被授信金额3
    ,thirdcreditcurrency  -- 被授信币种3
    ,thirdcreditparty  -- 被授信人3
    ,secondcreditsum  -- 被授信金额2
    ,secondcreditcurrency  -- 被授信币种2
    ,secondcreditparty  -- 被授信人2
    ,firstcreditsum  -- 被授信金额一
    ,firstcreditcurrency  -- 被授信币种一
    ,firstcreditparty  -- 被授信人一
    ,contractsum4  -- 担保债务金额3
    ,currency4  -- 担保债务币种3
    ,contractsum3  -- 担保债务金额
    ,currency3  -- 担保债务币种2
    ,contractsum2  -- 合同本金2
    ,currency2  -- 合同币种2
    ,contractname2  -- 合同名称2
    ,contractno2  -- 合同号2
    ,contractword2  -- 合同机构简称+编号类型2
    ,contractsum1  -- 担保债务本金1
    ,currency1  -- 担保债务币种1
    ,contractname  -- 合同名称1
    ,contractno1  -- 合同号1
    ,contractword  -- 合同机构简称+编号类型1
    ,partyacopies  -- 甲方执合同份数
    ,totalcopies  -- 合同总份数
    ,quoteguarantyquotano  -- 引入担保额度流水号
    ,quoteguarantyquota  -- 是否占用担保额度
    ,pigeonholedate  -- 归档日
    ,printflag  -- 追加担保合同打印标志
    ,guarantytype2  -- 担保类型分类
    ,financeitem6  -- 负债率（当期总负债／当期总资产）不高于
    ,financeitem7  -- 债务权益比率（当期总负债／当期净资产）不高于
    ,endtime  -- 担保到期日
    ,begintime  -- 担保起始日
    ,transfercreditrange  -- 被转贷款人范围
    ,compensatetype  -- 清偿处理方式
    ,maincontractsum  -- 主合同金额
    ,maincontractcurrency  -- 主合同币种
    ,maincontractname  -- 主合同名称
    ,otherparties  -- 其余各方当事人及有关登记部门
    ,otherpromise  -- 约定其他事项
    ,notarizationflag  -- 是否强制执行公证
    ,otherguarantyperiod2  -- 其他保证期间2
    ,otherguarantyperiod1  -- 其他保证期间1
    ,guarantyperiod  -- 保证期间
    ,otherguarantyrange  -- 其他担保范围
    ,guarantyrange  -- 担保范围
    ,textmaincontractno  -- 主合同文本编号
    ,partybduty  -- 借款人法定代表人职务
    ,partybpostcode  -- 借款人邮编
    ,partyblegalperson  -- 借款人法定代表人
    ,partybfax  -- 借款人传真
    ,partybphone  -- 借款人电话
    ,partybaddress  -- 借款人地址
    ,partybcertid  -- 借款人证件号码
    ,partybcerttype  -- 借款人证件种类
    ,partybname  -- 借款人名称
    ,partyaduty  -- 贷款人负责人职务
    ,partyaprincipal  -- 贷款人负责人
    ,partyafax  -- 贷款人传真
    ,partyaphone  -- 债权人电话
    ,partyaaddress  -- 贷款人地址
    ,orgname  -- 机构名称
    ,shortorg  -- 机构简称
    ,textcontractno  -- 文本合同编号
    ,ectempsaveflag  -- 暂存标志
    ,econtracttype  -- 电子合同类型
    ,vouchtype  -- 主要担保方式
    ,bailratio  -- 保证金比例
    ,commondate  -- 通用日期
    ,othername  -- 其他名称
    ,checkguarantyman2  -- 核保人（二）
    ,receptionduty  -- 接待人职务
    ,reception  -- 接待人姓名
    ,creditorgname  -- 债权人机构名称
    ,creditorgid  -- 债权人机构代码
    ,customerownership  -- 客户所有制类型
    ,channelflag  -- 渠道标志
    ,guarterm  -- 担保期限(月)
    ,usesum  -- 已担保金额
    ,guarbalance  -- 可用余额
    ,guarantyno  -- 担保合同编号
    ,guarantytype  -- 一般担保合同、最高额担保合同
    ,guarantystyle  -- 担保方式
    ,guarantystatus  -- 担保合同状态
    ,signdate  -- 协议签定日期
    ,begindate  -- 合同生效日
    ,enddate  -- 合同到期日
    ,customerid  -- 被担保人客户号
    ,guarantorid  -- 担保人编号
    ,guarantorname  -- 担保人名称
    ,guarantycurrency  -- 担保币种
    ,guarantyvalue  -- 担保总金额
    ,guarantyinfo  -- 担保物概况
    ,otherdescsribe  -- 其它特别约定
    ,guarantyopinion  -- 担保意见
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,migtflag  -- 迁移标志：crs rcr ilc upl
    ,guartorcate  -- 保证人类型(对公、对私)
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t.checkguarantydate,chr(13),''),chr(10),'') as checkguarantydate  -- 核保日期
    ,replace(replace(t.checkguarantymana,chr(13),''),chr(10),'') as checkguarantymana  -- 核保人;一）
    ,replace(replace(t.checkguarantymanb,chr(13),''),chr(10),'') as checkguarantymanb  -- 核保人;二）
    ,replace(replace(t.certtype,chr(13),''),chr(10),'') as certtype  -- 担保人证件类型
    ,replace(replace(t.certid,chr(13),''),chr(10),'') as certid  -- 担保人证件号码
    ,replace(replace(t.loancardno,chr(13),''),chr(10),'') as loancardno  -- 担保人贷款卡编号
    ,replace(replace(t.guaranteeform,chr(13),''),chr(10),'') as guaranteeform  -- 保证担保形式
    ,replace(replace(t.inputorgid,chr(13),''),chr(10),'') as inputorgid  -- 登记机构
    ,replace(replace(t.inputuserid,chr(13),''),chr(10),'') as inputuserid  -- 登记人
    ,t.inputdate as inputdate  -- 登记日期
    ,replace(replace(t.updateorgid,chr(13),''),chr(10),'') as updateorgid  -- 更新机构
    ,replace(replace(t.updateuserid,chr(13),''),chr(10),'') as updateuserid  -- 更新人
    ,t.updatedate as updatedate  -- 更新日期
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark  -- 备注
    ,replace(replace(t.corporgid,chr(13),''),chr(10),'') as corporgid  -- 法人机构编号
    ,replace(replace(t.authostrdate,chr(13),''),chr(10),'') as authostrdate  -- 授权起始日
    ,replace(replace(t.istranguaranty,chr(13),''),chr(10),'') as istranguaranty  -- 是否包含反担保措施
    ,replace(replace(t.isquerycreditreport,chr(13),''),chr(10),'') as isquerycreditreport  -- 征信查询授权书编号
    ,replace(replace(t.creditauthno,chr(13),''),chr(10),'') as creditauthno  -- 征信查询授权书编号
    ,replace(replace(t.industrytype,chr(13),''),chr(10),'') as industrytype  -- 国标行业分类
    ,replace(replace(t.enterprisescope,chr(13),''),chr(10),'') as enterprisescope  -- 企业规模
    ,replace(replace(t.ecodepartmentcode,chr(13),''),chr(10),'') as ecodepartmentcode  -- 国民经济部门
    ,replace(replace(t.newregioncode,chr(13),''),chr(10),'') as newregioncode  -- 注册地行政区划代码
    ,replace(replace(t.issaveowner,chr(13),''),chr(10),'') as issaveowner  -- 是否直接向我行担保
    ,replace(replace(t.obligeename,chr(13),''),chr(10),'') as obligeename  -- 权利人名称
    ,replace(replace(t.obligeeid,chr(13),''),chr(10),'') as obligeeid  -- 权利人客户编号
    ,replace(replace(t.iscustody,chr(13),''),chr(10),'') as iscustody  -- 是否代保管
    ,replace(replace(t.residentflag,chr(13),''),chr(10),'') as residentflag  -- 居民标志
    ,replace(replace(t.registationcode,chr(13),''),chr(10),'') as registationcode  -- 注册国家/地区代码
    ,t.guarantyorsum as guarantyorsum  -- 保证人净资产
    ,replace(replace(t.ypguarantorid,chr(13),''),chr(10),'') as ypguarantorid  -- 押品系统保证人id
    ,replace(replace(t.guarantyfax,chr(13),''),chr(10),'') as guarantyfax  -- 保证人传真
    ,replace(replace(t.guarantyphone,chr(13),''),chr(10),'') as guarantyphone  -- 保证人电话
    ,replace(replace(t.guarantyaddress,chr(13),''),chr(10),'') as guarantyaddress  -- 保证人地址
    ,replace(replace(t.isinuse,chr(13),''),chr(10),'') as isinuse  -- 添加维护标志1正常2不维护
    ,replace(replace(t.preserialno,chr(13),''),chr(10),'') as preserialno  -- 被拷贝的担保流水号
    ,replace(replace(t.creditaggreement,chr(13),''),chr(10),'') as creditaggreement  -- 额度协议流水号
    ,t.thirdcreditsum as thirdcreditsum  -- 被授信金额3
    ,replace(replace(t.thirdcreditcurrency,chr(13),''),chr(10),'') as thirdcreditcurrency  -- 被授信币种3
    ,replace(replace(t.thirdcreditparty,chr(13),''),chr(10),'') as thirdcreditparty  -- 被授信人3
    ,t.secondcreditsum as secondcreditsum  -- 被授信金额2
    ,replace(replace(t.secondcreditcurrency,chr(13),''),chr(10),'') as secondcreditcurrency  -- 被授信币种2
    ,replace(replace(t.secondcreditparty,chr(13),''),chr(10),'') as secondcreditparty  -- 被授信人2
    ,t.firstcreditsum as firstcreditsum  -- 被授信金额一
    ,replace(replace(t.firstcreditcurrency,chr(13),''),chr(10),'') as firstcreditcurrency  -- 被授信币种一
    ,replace(replace(t.firstcreditparty,chr(13),''),chr(10),'') as firstcreditparty  -- 被授信人一
    ,t.contractsum4 as contractsum4  -- 担保债务金额3
    ,replace(replace(t.currency4,chr(13),''),chr(10),'') as currency4  -- 担保债务币种3
    ,t.contractsum3 as contractsum3  -- 担保债务金额
    ,replace(replace(t.currency3,chr(13),''),chr(10),'') as currency3  -- 担保债务币种2
    ,t.contractsum2 as contractsum2  -- 合同本金2
    ,replace(replace(t.currency2,chr(13),''),chr(10),'') as currency2  -- 合同币种2
    ,replace(replace(t.contractname2,chr(13),''),chr(10),'') as contractname2  -- 合同名称2
    ,replace(replace(t.contractno2,chr(13),''),chr(10),'') as contractno2  -- 合同号2
    ,replace(replace(t.contractword2,chr(13),''),chr(10),'') as contractword2  -- 合同机构简称+编号类型2
    ,t.contractsum1 as contractsum1  -- 担保债务本金1
    ,replace(replace(t.currency1,chr(13),''),chr(10),'') as currency1  -- 担保债务币种1
    ,replace(replace(t.contractname,chr(13),''),chr(10),'') as contractname  -- 合同名称1
    ,replace(replace(t.contractno1,chr(13),''),chr(10),'') as contractno1  -- 合同号1
    ,replace(replace(t.contractword,chr(13),''),chr(10),'') as contractword  -- 合同机构简称+编号类型1
    ,replace(replace(t.partyacopies,chr(13),''),chr(10),'') as partyacopies  -- 甲方执合同份数
    ,replace(replace(t.totalcopies,chr(13),''),chr(10),'') as totalcopies  -- 合同总份数
    ,replace(replace(t.quoteguarantyquotano,chr(13),''),chr(10),'') as quoteguarantyquotano  -- 引入担保额度流水号
    ,replace(replace(t.quoteguarantyquota,chr(13),''),chr(10),'') as quoteguarantyquota  -- 是否占用担保额度
    ,replace(replace(t.pigeonholedate,chr(13),''),chr(10),'') as pigeonholedate  -- 归档日
    ,replace(replace(t.printflag,chr(13),''),chr(10),'') as printflag  -- 追加担保合同打印标志
    ,replace(replace(t.guarantytype2,chr(13),''),chr(10),'') as guarantytype2  -- 担保类型分类
    ,replace(replace(t.financeitem6,chr(13),''),chr(10),'') as financeitem6  -- 负债率（当期总负债／当期总资产）不高于
    ,replace(replace(t.financeitem7,chr(13),''),chr(10),'') as financeitem7  -- 债务权益比率（当期总负债／当期净资产）不高于
    ,replace(replace(t.endtime,chr(13),''),chr(10),'') as endtime  -- 担保到期日
    ,replace(replace(t.begintime,chr(13),''),chr(10),'') as begintime  -- 担保起始日
    ,replace(replace(t.transfercreditrange,chr(13),''),chr(10),'') as transfercreditrange  -- 被转贷款人范围
    ,replace(replace(t.compensatetype,chr(13),''),chr(10),'') as compensatetype  -- 清偿处理方式
    ,t.maincontractsum as maincontractsum  -- 主合同金额
    ,replace(replace(t.maincontractcurrency,chr(13),''),chr(10),'') as maincontractcurrency  -- 主合同币种
    ,replace(replace(t.maincontractname,chr(13),''),chr(10),'') as maincontractname  -- 主合同名称
    ,replace(replace(t.otherparties,chr(13),''),chr(10),'') as otherparties  -- 其余各方当事人及有关登记部门
    ,replace(replace(t.otherpromise,chr(13),''),chr(10),'') as otherpromise  -- 约定其他事项
    ,replace(replace(t.notarizationflag,chr(13),''),chr(10),'') as notarizationflag  -- 是否强制执行公证
    ,replace(replace(t.otherguarantyperiod2,chr(13),''),chr(10),'') as otherguarantyperiod2  -- 其他保证期间2
    ,replace(replace(t.otherguarantyperiod1,chr(13),''),chr(10),'') as otherguarantyperiod1  -- 其他保证期间1
    ,replace(replace(t.guarantyperiod,chr(13),''),chr(10),'') as guarantyperiod  -- 保证期间
    ,replace(replace(t.otherguarantyrange,chr(13),''),chr(10),'') as otherguarantyrange  -- 其他担保范围
    ,replace(replace(t.guarantyrange,chr(13),''),chr(10),'') as guarantyrange  -- 担保范围
    ,replace(replace(t.textmaincontractno,chr(13),''),chr(10),'') as textmaincontractno  -- 主合同文本编号
    ,replace(replace(t.partybduty,chr(13),''),chr(10),'') as partybduty  -- 借款人法定代表人职务
    ,replace(replace(t.partybpostcode,chr(13),''),chr(10),'') as partybpostcode  -- 借款人邮编
    ,replace(replace(t.partyblegalperson,chr(13),''),chr(10),'') as partyblegalperson  -- 借款人法定代表人
    ,replace(replace(t.partybfax,chr(13),''),chr(10),'') as partybfax  -- 借款人传真
    ,replace(replace(t.partybphone,chr(13),''),chr(10),'') as partybphone  -- 借款人电话
    ,replace(replace(t.partybaddress,chr(13),''),chr(10),'') as partybaddress  -- 借款人地址
    ,replace(replace(t.partybcertid,chr(13),''),chr(10),'') as partybcertid  -- 借款人证件号码
    ,replace(replace(t.partybcerttype,chr(13),''),chr(10),'') as partybcerttype  -- 借款人证件种类
    ,replace(replace(t.partybname,chr(13),''),chr(10),'') as partybname  -- 借款人名称
    ,replace(replace(t.partyaduty,chr(13),''),chr(10),'') as partyaduty  -- 贷款人负责人职务
    ,replace(replace(t.partyaprincipal,chr(13),''),chr(10),'') as partyaprincipal  -- 贷款人负责人
    ,replace(replace(t.partyafax,chr(13),''),chr(10),'') as partyafax  -- 贷款人传真
    ,replace(replace(t.partyaphone,chr(13),''),chr(10),'') as partyaphone  -- 债权人电话
    ,replace(replace(t.partyaaddress,chr(13),''),chr(10),'') as partyaaddress  -- 贷款人地址
    ,replace(replace(t.orgname,chr(13),''),chr(10),'') as orgname  -- 机构名称
    ,replace(replace(t.shortorg,chr(13),''),chr(10),'') as shortorg  -- 机构简称
    ,replace(replace(t.textcontractno,chr(13),''),chr(10),'') as textcontractno  -- 文本合同编号
    ,replace(replace(t.ectempsaveflag,chr(13),''),chr(10),'') as ectempsaveflag  -- 暂存标志
    ,replace(replace(t.econtracttype,chr(13),''),chr(10),'') as econtracttype  -- 电子合同类型
    ,replace(replace(t.vouchtype,chr(13),''),chr(10),'') as vouchtype  -- 主要担保方式
    ,t.bailratio as bailratio  -- 保证金比例
    ,replace(replace(t.commondate,chr(13),''),chr(10),'') as commondate  -- 通用日期
    ,replace(replace(t.othername,chr(13),''),chr(10),'') as othername  -- 其他名称
    ,replace(replace(t.checkguarantyman2,chr(13),''),chr(10),'') as checkguarantyman2  -- 核保人（二）
    ,replace(replace(t.receptionduty,chr(13),''),chr(10),'') as receptionduty  -- 接待人职务
    ,replace(replace(t.reception,chr(13),''),chr(10),'') as reception  -- 接待人姓名
    ,replace(replace(t.creditorgname,chr(13),''),chr(10),'') as creditorgname  -- 债权人机构名称
    ,replace(replace(t.creditorgid,chr(13),''),chr(10),'') as creditorgid  -- 债权人机构代码
    ,replace(replace(t.customerownership,chr(13),''),chr(10),'') as customerownership  -- 客户所有制类型
    ,replace(replace(t.channelflag,chr(13),''),chr(10),'') as channelflag  -- 渠道标志
    ,t.guarterm as guarterm  -- 担保期限(月)
    ,t.usesum as usesum  -- 已担保金额
    ,t.guarbalance as guarbalance  -- 可用余额
    ,replace(replace(t.guarantyno,chr(13),''),chr(10),'') as guarantyno  -- 担保合同编号
    ,replace(replace(t.guarantytype,chr(13),''),chr(10),'') as guarantytype  -- 一般担保合同、最高额担保合同
    ,replace(replace(t.guarantystyle,chr(13),''),chr(10),'') as guarantystyle  -- 担保方式
    ,replace(replace(t.guarantystatus,chr(13),''),chr(10),'') as guarantystatus  -- 担保合同状态
    ,replace(replace(t.signdate,chr(13),''),chr(10),'') as signdate  -- 协议签定日期
    ,replace(replace(t.begindate,chr(13),''),chr(10),'') as begindate  -- 合同生效日
    ,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate  -- 合同到期日
    ,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid  -- 被担保人客户号
    ,replace(replace(t.guarantorid,chr(13),''),chr(10),'') as guarantorid  -- 担保人编号
    ,replace(replace(t.guarantorname,chr(13),''),chr(10),'') as guarantorname  -- 担保人名称
    ,replace(replace(t.guarantycurrency,chr(13),''),chr(10),'') as guarantycurrency  -- 担保币种
    ,t.guarantyvalue as guarantyvalue  -- 担保总金额
    ,replace(replace(t.guarantyinfo,chr(13),''),chr(10),'') as guarantyinfo  -- 担保物概况
    ,replace(replace(t.otherdescsribe,chr(13),''),chr(10),'') as otherdescsribe  -- 其它特别约定
    ,replace(replace(t.guarantyopinion,chr(13),''),chr(10),'') as guarantyopinion  -- 担保意见
    ,t.start_dt as start_dt  -- 开始日期
    ,t.end_dt as end_dt  -- 结束日期
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark  -- 删除标识
    ,replace(replace(t.migtflag,chr(13),''),chr(10),'') as migtflag  -- 迁移标志：crs rcr ilc upl
    ,replace(replace(t.guartorcate,chr(13),''),chr(10),'') as guartorcate  -- 保证人类型(对公、对私)
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 时间戳
 from ${iol_schema}.icms_guaranty_contract t--担保合同类型
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.icms_guaranty_contract to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_guaranty_contract',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);