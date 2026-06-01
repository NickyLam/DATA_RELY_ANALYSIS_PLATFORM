/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_wind_cbonddescription
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_wind_cbonddescription drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_wind_cbonddescription add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_wind_cbonddescription (
etl_dt  --数据日期
,b_info_fullname  --债券名称
,b_info_issuer  --发行人
,b_issue_announcement  --发行公告日
,b_issue_firstissue  --发行起始日
,b_issue_lastissue  --发行截止日
,b_issue_amountplan  --计划发行总量(亿元)
,b_issue_amountact  --实际发行总量(亿元)
,b_info_issueprice  --发行价格
,b_info_par  --面值
,b_info_couponrate  --发行票面利率(%)
,b_info_spread  --利差(%)
,b_info_carrydate  --计息起始日
,b_info_enddate  --计息截止日
,b_info_maturitydate  --到期日
,b_info_term_year_  --债券期限(年)
,b_info_term_day_  --债券期限(天)
,b_info_paymentdate  --兑付日
,b_info_paymenttype  --计息方式
,b_info_interestfrequency  --付息频率
,b_info_form  --债券形式
,b_info_coupon  --息票品种
,b_info_interesttype  --附息利率品种
,b_info_act  --特殊年计息天数
,b_issue_fee  --发行手续费率(%)
,b_redemption_feeration  --兑付手续费率(%)
,b_info_taxrate  --所得税率
,crncy_code  --货币代码
,s_info_name  --债券简称
,s_info_exchmarket  --交易所
,b_info_guarantor  --担保人
,b_info_guartype  --担保方式
,b_info_listdate  --上市日期
,b_info_yearsnumber  --年内序号
,s_div_recorddate  --兑付登记起始日
,b_info_codebyplacing  --上网发行认购代码
,b_info_delistdate  --退市日期
,b_info_issuetype  --发行方式
,b_info_guarintroduction  --担保简介
,b_info_bgndbyplacing  --上网发行起始日期
,b_info_enddbyplacing  --上网发行截止日期
,b_info_amountbyplacing  --上网发行数量(亿元)
,b_info_underwritingcode  --承销方式代码
,b_info_issuercode  --发行人编号
,b_info_formercode  --原债券代码
,b_info_coupontxt  --利率说明
,is_failure  --是否发行失败
,is_crossmarket  --是否跨市场
,b_info_coupondatetxt  --付息日说明
,b_info_subordinateornot  --是否次级债或混合资本债
,b_tendrst_referyield  --参考收益率
,b_info_curpar  --最新面值
,s_info_formerwindcode  --原Wind代码
,is_corporate_bond  --是否公司债
,b_info_issuertype  --发行人类型
,b_info_specialbondtype  --特殊债券类型
,is_payadvanced  --是否可提前兑付
,is_callable  --是否可赎回
,is_chooseright  --是否有选择权
,is_netprice  --是否净价
,is_act_days  --是否按实际天数计息
,is_incbonds  --是否增发债
,issue_object  --发行对象
,b_info_actualbenchmark  --计息基准
,register_file_type_code  --注册文件类型代码
,register_file_number  --注册文件号
,list_ann_date  --上市公告日
,start_dt  --开始时间
,end_dt  --结束时间
,object_id  --对象ID
,id_mark  --增删标志
,s_info_windcode  --Wind代码

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.b_info_fullname,chr(13),''),chr(10),'') as b_info_fullname --债券名称
,replace(replace(t1.b_info_issuer,chr(13),''),chr(10),'') as b_info_issuer --发行人
,replace(replace(t1.b_issue_announcement,chr(13),''),chr(10),'') as b_issue_announcement --发行公告日
,replace(replace(t1.b_issue_firstissue,chr(13),''),chr(10),'') as b_issue_firstissue --发行起始日
,replace(replace(t1.b_issue_lastissue,chr(13),''),chr(10),'') as b_issue_lastissue --发行截止日
,t1.b_issue_amountplan as b_issue_amountplan --计划发行总量(亿元)
,t1.b_issue_amountact as b_issue_amountact --实际发行总量(亿元)
,t1.b_info_issueprice as b_info_issueprice --发行价格
,t1.b_info_par as b_info_par --面值
,t1.b_info_couponrate as b_info_couponrate --发行票面利率(%)
,t1.b_info_spread as b_info_spread --利差(%)
,replace(replace(t1.b_info_carrydate,chr(13),''),chr(10),'') as b_info_carrydate --计息起始日
,replace(replace(t1.b_info_enddate,chr(13),''),chr(10),'') as b_info_enddate --计息截止日
,replace(replace(t1.b_info_maturitydate,chr(13),''),chr(10),'') as b_info_maturitydate --到期日
,t1.b_info_term_year_ as b_info_term_year_ --债券期限(年)
,t1.b_info_term_day_ as b_info_term_day_ --债券期限(天)
,replace(replace(t1.b_info_paymentdate,chr(13),''),chr(10),'') as b_info_paymentdate --兑付日
,t1.b_info_paymenttype as b_info_paymenttype --计息方式
,replace(replace(t1.b_info_interestfrequency,chr(13),''),chr(10),'') as b_info_interestfrequency --付息频率
,replace(replace(t1.b_info_form,chr(13),''),chr(10),'') as b_info_form --债券形式
,t1.b_info_coupon as b_info_coupon --息票品种
,t1.b_info_interesttype as b_info_interesttype --附息利率品种
,t1.b_info_act as b_info_act --特殊年计息天数
,t1.b_issue_fee as b_issue_fee --发行手续费率(%)
,t1.b_redemption_feeration as b_redemption_feeration --兑付手续费率(%)
,t1.b_info_taxrate as b_info_taxrate --所得税率
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code --货币代码
,replace(replace(t1.s_info_name,chr(13),''),chr(10),'') as s_info_name --债券简称
,replace(replace(t1.s_info_exchmarket,chr(13),''),chr(10),'') as s_info_exchmarket --交易所
,replace(replace(t1.b_info_guarantor,chr(13),''),chr(10),'') as b_info_guarantor --担保人
,t1.b_info_guartype as b_info_guartype --担保方式
,replace(replace(t1.b_info_listdate,chr(13),''),chr(10),'') as b_info_listdate --上市日期
,t1.b_info_yearsnumber as b_info_yearsnumber --年内序号
,replace(replace(t1.s_div_recorddate,chr(13),''),chr(10),'') as s_div_recorddate --兑付登记起始日
,replace(replace(t1.b_info_codebyplacing,chr(13),''),chr(10),'') as b_info_codebyplacing --上网发行认购代码
,replace(replace(t1.b_info_delistdate,chr(13),''),chr(10),'') as b_info_delistdate --退市日期
,t1.b_info_issuetype as b_info_issuetype --发行方式
,replace(replace(t1.b_info_guarintroduction,chr(13),''),chr(10),'') as b_info_guarintroduction --担保简介
,replace(replace(t1.b_info_bgndbyplacing,chr(13),''),chr(10),'') as b_info_bgndbyplacing --上网发行起始日期
,replace(replace(t1.b_info_enddbyplacing,chr(13),''),chr(10),'') as b_info_enddbyplacing --上网发行截止日期
,t1.b_info_amountbyplacing as b_info_amountbyplacing --上网发行数量(亿元)
,t1.b_info_underwritingcode as b_info_underwritingcode --承销方式代码
,replace(replace(t1.b_info_issuercode,chr(13),''),chr(10),'') as b_info_issuercode --发行人编号
,replace(replace(t1.b_info_formercode,chr(13),''),chr(10),'') as b_info_formercode --原债券代码
,replace(replace(t1.b_info_coupontxt,chr(13),''),chr(10),'') as b_info_coupontxt --利率说明
,t1.is_failure as is_failure --是否发行失败
,t1.is_crossmarket as is_crossmarket --是否跨市场
,replace(replace(t1.b_info_coupondatetxt,chr(13),''),chr(10),'') as b_info_coupondatetxt --付息日说明
,t1.b_info_subordinateornot as b_info_subordinateornot --是否次级债或混合资本债
,t1.b_tendrst_referyield as b_tendrst_referyield --参考收益率
,t1.b_info_curpar as b_info_curpar --最新面值
,replace(replace(t1.s_info_formerwindcode,chr(13),''),chr(10),'') as s_info_formerwindcode --原Wind代码
,t1.is_corporate_bond as is_corporate_bond --是否公司债
,replace(replace(t1.b_info_issuertype,chr(13),''),chr(10),'') as b_info_issuertype --发行人类型
,replace(replace(t1.b_info_specialbondtype,chr(13),''),chr(10),'') as b_info_specialbondtype --特殊债券类型
,replace(replace(t1.is_payadvanced,chr(13),''),chr(10),'') as is_payadvanced --是否可提前兑付
,replace(replace(t1.is_callable,chr(13),''),chr(10),'') as is_callable --是否可赎回
,replace(replace(t1.is_chooseright,chr(13),''),chr(10),'') as is_chooseright --是否有选择权
,t1.is_netprice as is_netprice --是否净价
,t1.is_act_days as is_act_days --是否按实际天数计息
,t1.is_incbonds as is_incbonds --是否增发债
,replace(replace(t1.issue_object,chr(13),''),chr(10),'') as issue_object --发行对象
,replace(replace(t1.b_info_actualbenchmark,chr(13),''),chr(10),'') as b_info_actualbenchmark --计息基准
,t1.register_file_type_code as register_file_type_code --注册文件类型代码
,replace(replace(t1.register_file_number,chr(13),''),chr(10),'') as register_file_number --注册文件号
,replace(replace(t1.list_ann_date,chr(13),''),chr(10),'') as list_ann_date --上市公告日
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id --对象ID
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode --Wind代码
from ${iol_schema}.wind_cbonddescription t1    --中国债券基本资料
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_wind_cbonddescription',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
