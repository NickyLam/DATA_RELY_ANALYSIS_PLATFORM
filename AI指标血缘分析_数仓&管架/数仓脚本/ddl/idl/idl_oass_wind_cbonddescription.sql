/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_wind_cbonddescription
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_wind_cbonddescription purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_wind_cbonddescription(
etl_dt date --数据日期
,b_info_fullname varchar2(750) --债券名称
,b_info_issuer varchar2(150) --发行人
,b_issue_announcement varchar2(12) --发行公告日
,b_issue_firstissue varchar2(12) --发行起始日
,b_issue_lastissue varchar2(12) --发行截止日
,b_issue_amountplan number(26,10) --计划发行总量(亿元)
,b_issue_amountact number(26,10) --实际发行总量(亿元)
,b_info_issueprice number(20,4) --发行价格
,b_info_par number(20,0) --面值
,b_info_couponrate number(22,6) --发行票面利率(%)
,b_info_spread number(20,4) --利差(%)
,b_info_carrydate varchar2(12) --计息起始日
,b_info_enddate varchar2(12) --计息截止日
,b_info_maturitydate varchar2(12) --到期日
,b_info_term_year_ number(20,4) --债券期限(年)
,b_info_term_day_ number(20,4) --债券期限(天)
,b_info_paymentdate varchar2(12) --兑付日
,b_info_paymenttype number(9,0) --计息方式
,b_info_interestfrequency varchar2(30) --付息频率
,b_info_form varchar2(15) --债券形式
,b_info_coupon number(9,0) --息票品种
,b_info_interesttype number(9,0) --附息利率品种
,b_info_act number(20,4) --特殊年计息天数
,b_issue_fee number(20,4) --发行手续费率(%)
,b_redemption_feeration number(20,4) --兑付手续费率(%)
,b_info_taxrate number(20,4) --所得税率
,crncy_code varchar2(15) --货币代码
,s_info_name varchar2(150) --债券简称
,s_info_exchmarket varchar2(15) --交易所
,b_info_guarantor varchar2(150) --担保人
,b_info_guartype number(9,0) --担保方式
,b_info_listdate varchar2(12) --上市日期
,b_info_yearsnumber number(20,0) --年内序号
,s_div_recorddate varchar2(12) --兑付登记起始日
,b_info_codebyplacing varchar2(15) --上网发行认购代码
,b_info_delistdate varchar2(12) --退市日期
,b_info_issuetype number(9,0) --发行方式
,b_info_guarintroduction varchar2(1500) --担保简介
,b_info_bgndbyplacing varchar2(12) --上网发行起始日期
,b_info_enddbyplacing varchar2(12) --上网发行截止日期
,b_info_amountbyplacing number(26,10) --上网发行数量(亿元)
,b_info_underwritingcode number(9,0) --承销方式代码
,b_info_issuercode varchar2(150) --发行人编号
,b_info_formercode varchar2(60) --原债券代码
,b_info_coupontxt varchar2(3000) --利率说明
,is_failure number(5,0) --是否发行失败
,is_crossmarket number(5,0) --是否跨市场
,b_info_coupondatetxt varchar2(3000) --付息日说明
,b_info_subordinateornot number(5,0) --是否次级债或混合资本债
,b_tendrst_referyield number(20,4) --参考收益率
,b_info_curpar number(20,4) --最新面值
,s_info_formerwindcode varchar2(60) --原Wind代码
,is_corporate_bond number(5,0) --是否公司债
,b_info_issuertype varchar2(150) --发行人类型
,b_info_specialbondtype varchar2(60) --特殊债券类型
,is_payadvanced varchar2(2) --是否可提前兑付
,is_callable varchar2(2) --是否可赎回
,is_chooseright varchar2(2) --是否有选择权
,is_netprice number(1,0) --是否净价
,is_act_days number(1,0) --是否按实际天数计息
,is_incbonds number(5,0) --是否增发债
,issue_object varchar2(150) --发行对象
,b_info_actualbenchmark varchar2(12) --计息基准
,register_file_type_code number(9,0) --注册文件类型代码
,register_file_number varchar2(1500) --注册文件号
,list_ann_date varchar2(12) --上市公告日
,start_dt date --开始时间
,end_dt date --结束时间
,object_id varchar2(150) --对象ID
,id_mark varchar2(10) --增删标志
,s_info_windcode varchar2(60) --Wind代码

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_wind_cbonddescription to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_wind_cbonddescription is '中国债券基本资料';
comment on column ${idl_schema}.oass_wind_cbonddescription.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_fullname is '债券名称';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_issuer is '发行人';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_issue_announcement is '发行公告日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_issue_firstissue is '发行起始日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_issue_lastissue is '发行截止日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_issue_amountplan is '计划发行总量(亿元)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_issue_amountact is '实际发行总量(亿元)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_issueprice is '发行价格';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_par is '面值';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_couponrate is '发行票面利率(%)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_spread is '利差(%)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_carrydate is '计息起始日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_enddate is '计息截止日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_maturitydate is '到期日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_term_year_ is '债券期限(年)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_term_day_ is '债券期限(天)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_paymentdate is '兑付日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_paymenttype is '计息方式';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_interestfrequency is '付息频率';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_form is '债券形式';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_coupon is '息票品种';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_interesttype is '附息利率品种';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_act is '特殊年计息天数';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_issue_fee is '发行手续费率(%)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_redemption_feeration is '兑付手续费率(%)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_taxrate is '所得税率';
comment on column ${idl_schema}.oass_wind_cbonddescription.crncy_code is '货币代码';
comment on column ${idl_schema}.oass_wind_cbonddescription.s_info_name is '债券简称';
comment on column ${idl_schema}.oass_wind_cbonddescription.s_info_exchmarket is '交易所';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_guarantor is '担保人';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_guartype is '担保方式';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_listdate is '上市日期';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_yearsnumber is '年内序号';
comment on column ${idl_schema}.oass_wind_cbonddescription.s_div_recorddate is '兑付登记起始日';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_codebyplacing is '上网发行认购代码';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_delistdate is '退市日期';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_issuetype is '发行方式';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_guarintroduction is '担保简介';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_bgndbyplacing is '上网发行起始日期';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_enddbyplacing is '上网发行截止日期';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_amountbyplacing is '上网发行数量(亿元)';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_underwritingcode is '承销方式代码';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_issuercode is '发行人编号';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_formercode is '原债券代码';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_coupontxt is '利率说明';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_failure is '是否发行失败';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_crossmarket is '是否跨市场';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_coupondatetxt is '付息日说明';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_subordinateornot is '是否次级债或混合资本债';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_tendrst_referyield is '参考收益率';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_curpar is '最新面值';
comment on column ${idl_schema}.oass_wind_cbonddescription.s_info_formerwindcode is '原Wind代码';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_corporate_bond is '是否公司债';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_issuertype is '发行人类型';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_specialbondtype is '特殊债券类型';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_payadvanced is '是否可提前兑付';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_callable is '是否可赎回';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_chooseright is '是否有选择权';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_netprice is '是否净价';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_act_days is '是否按实际天数计息';
comment on column ${idl_schema}.oass_wind_cbonddescription.is_incbonds is '是否增发债';
comment on column ${idl_schema}.oass_wind_cbonddescription.issue_object is '发行对象';
comment on column ${idl_schema}.oass_wind_cbonddescription.b_info_actualbenchmark is '计息基准';
comment on column ${idl_schema}.oass_wind_cbonddescription.register_file_type_code is '注册文件类型代码';
comment on column ${idl_schema}.oass_wind_cbonddescription.register_file_number is '注册文件号';
comment on column ${idl_schema}.oass_wind_cbonddescription.list_ann_date is '上市公告日';
comment on column ${idl_schema}.oass_wind_cbonddescription.start_dt is '开始时间';
comment on column ${idl_schema}.oass_wind_cbonddescription.end_dt is '结束时间';
comment on column ${idl_schema}.oass_wind_cbonddescription.object_id is '对象ID';
comment on column ${idl_schema}.oass_wind_cbonddescription.id_mark is '增删标志';
comment on column ${idl_schema}.oass_wind_cbonddescription.s_info_windcode is 'Wind代码';

