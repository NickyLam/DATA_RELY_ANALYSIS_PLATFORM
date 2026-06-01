/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbinsurerate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbinsurerate
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbinsurerate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurerate(
    ta_code varchar2(14) -- 保险公司代码
    ,prd_code varchar2(30) -- 产品代码
    ,trans_type varchar2(3) -- 交易类型，查询tbdict表中b_jylx
    ,branch_no varchar2(24) -- 所属于机构
    ,pay_year_type varchar2(2) -- 缴费年期类型：
    ,pay_year varchar2(5) -- 缴费年期
    ,fee_type varchar2(2) -- 计算类型，0免收1单笔固定金额2按百分比收3每批固定金额
    ,fee_number number(18,4) -- 计算参数
    ,up_down_flag varchar2(2) -- 上下限控制标志
    ,per_max_amt number(18,2) -- 单笔最大金额
    ,per_min_amt number(18,2) -- 单笔最小金额
    ,offer_charge number(18,2) -- 出单费
    ,channel varchar2(15) -- 交易渠道
    ,reserve varchar2(375) -- 保留字段
    ,insure_year_type varchar2(2) -- 保障年期类型
    ,insure_year varchar2(5) -- 保障年期
    ,min_insure_fee number(18,2) -- 单笔最低保费
    ,max_insure_fee number(18,2) -- 单笔最高保费
    ,insure_annual number(22,0) -- 保险年度
    ,amt1 number(18,2) -- 保留金额1
    ,amt2 number(18,2) -- 保留金额2
    ,amt3 number(18,2) -- 保留金额3
    ,reserve1 varchar2(375) -- 保留字段1
    ,reserve2 varchar2(375) -- 保留字段2
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_tbinsurerate to ${iml_schema};
grant select on ${iol_schema}.ifms_tbinsurerate to ${icl_schema};
grant select on ${iol_schema}.ifms_tbinsurerate to ${idl_schema};
grant select on ${iol_schema}.ifms_tbinsurerate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbinsurerate is '保险费率';
comment on column ${iol_schema}.ifms_tbinsurerate.ta_code is '保险公司代码';
comment on column ${iol_schema}.ifms_tbinsurerate.prd_code is '产品代码';
comment on column ${iol_schema}.ifms_tbinsurerate.trans_type is '交易类型，查询tbdict表中b_jylx';
comment on column ${iol_schema}.ifms_tbinsurerate.branch_no is '所属于机构';
comment on column ${iol_schema}.ifms_tbinsurerate.pay_year_type is '缴费年期类型：';
comment on column ${iol_schema}.ifms_tbinsurerate.pay_year is '缴费年期';
comment on column ${iol_schema}.ifms_tbinsurerate.fee_type is '计算类型，0免收1单笔固定金额2按百分比收3每批固定金额';
comment on column ${iol_schema}.ifms_tbinsurerate.fee_number is '计算参数';
comment on column ${iol_schema}.ifms_tbinsurerate.up_down_flag is '上下限控制标志';
comment on column ${iol_schema}.ifms_tbinsurerate.per_max_amt is '单笔最大金额';
comment on column ${iol_schema}.ifms_tbinsurerate.per_min_amt is '单笔最小金额';
comment on column ${iol_schema}.ifms_tbinsurerate.offer_charge is '出单费';
comment on column ${iol_schema}.ifms_tbinsurerate.channel is '交易渠道';
comment on column ${iol_schema}.ifms_tbinsurerate.reserve is '保留字段';
comment on column ${iol_schema}.ifms_tbinsurerate.insure_year_type is '保障年期类型';
comment on column ${iol_schema}.ifms_tbinsurerate.insure_year is '保障年期';
comment on column ${iol_schema}.ifms_tbinsurerate.min_insure_fee is '单笔最低保费';
comment on column ${iol_schema}.ifms_tbinsurerate.max_insure_fee is '单笔最高保费';
comment on column ${iol_schema}.ifms_tbinsurerate.insure_annual is '保险年度';
comment on column ${iol_schema}.ifms_tbinsurerate.amt1 is '保留金额1';
comment on column ${iol_schema}.ifms_tbinsurerate.amt2 is '保留金额2';
comment on column ${iol_schema}.ifms_tbinsurerate.amt3 is '保留金额3';
comment on column ${iol_schema}.ifms_tbinsurerate.reserve1 is '保留字段1';
comment on column ${iol_schema}.ifms_tbinsurerate.reserve2 is '保留字段2';
comment on column ${iol_schema}.ifms_tbinsurerate.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbinsurerate.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbinsurerate.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbinsurerate.etl_timestamp is 'ETL处理时间戳';
