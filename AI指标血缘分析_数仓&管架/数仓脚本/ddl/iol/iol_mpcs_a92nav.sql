/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92nav
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92nav
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92nav purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92nav(
    paysys varchar2(15) -- 服务方简称
    ,instid varchar2(15) -- 接入商户号
    ,navdate varchar2(12) -- 净值日期
    ,fundcode varchar2(45) -- 基金代码
    ,nav number(17,4) -- 单位净值
    ,accumulatednav number(17,4) -- 累计净值
    ,returnday number(12,6) -- 日涨幅
    ,unityield number(12,6) -- 万份收益
    ,yearlyroe number(12,6) -- 七日年化收益率
    ,uptdatetime varchar2(30) -- 更新日期
    ,reserve1 varchar2(75) -- 备用字段1
    ,reserve2 varchar2(75) -- 备用字段2
    ,reserve3 varchar2(150) -- 备用字段3
    ,reserve4 varchar2(150) -- 备用字段4
    ,reserve5 varchar2(375) -- 备用字段5
    ,reserve6 varchar2(375) -- 备用字段6
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a92nav to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92nav to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92nav to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92nav to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92nav is '盈米基金净值表';
comment on column ${iol_schema}.mpcs_a92nav.paysys is '服务方简称';
comment on column ${iol_schema}.mpcs_a92nav.instid is '接入商户号';
comment on column ${iol_schema}.mpcs_a92nav.navdate is '净值日期';
comment on column ${iol_schema}.mpcs_a92nav.fundcode is '基金代码';
comment on column ${iol_schema}.mpcs_a92nav.nav is '单位净值';
comment on column ${iol_schema}.mpcs_a92nav.accumulatednav is '累计净值';
comment on column ${iol_schema}.mpcs_a92nav.returnday is '日涨幅';
comment on column ${iol_schema}.mpcs_a92nav.unityield is '万份收益';
comment on column ${iol_schema}.mpcs_a92nav.yearlyroe is '七日年化收益率';
comment on column ${iol_schema}.mpcs_a92nav.uptdatetime is '更新日期';
comment on column ${iol_schema}.mpcs_a92nav.reserve1 is '备用字段1';
comment on column ${iol_schema}.mpcs_a92nav.reserve2 is '备用字段2';
comment on column ${iol_schema}.mpcs_a92nav.reserve3 is '备用字段3';
comment on column ${iol_schema}.mpcs_a92nav.reserve4 is '备用字段4';
comment on column ${iol_schema}.mpcs_a92nav.reserve5 is '备用字段5';
comment on column ${iol_schema}.mpcs_a92nav.reserve6 is '备用字段6';
comment on column ${iol_schema}.mpcs_a92nav.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a92nav.etl_timestamp is 'ETL处理时间戳';
