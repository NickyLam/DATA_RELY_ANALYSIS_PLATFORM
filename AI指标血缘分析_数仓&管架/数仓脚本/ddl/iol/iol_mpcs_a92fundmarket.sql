/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92fundmarket
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92fundmarket
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92fundmarket purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92fundmarket(
    paysys varchar2(15) -- 服务方简称
    ,instid varchar2(15) -- 接入商户号
    ,navdate varchar2(12) -- 净值日期
    ,fundcode varchar2(45) -- 基金代码
    ,nav number(17,4) -- 单位净值
    ,accumulatednav number(17,4) -- 累计净值
    ,returnday number(12,6) -- 日涨幅
    ,unityield number(12,6) -- 万份收益
    ,yearlyroe number(12,6) -- 七日年化收益率
    ,statusdate varchar2(12) -- 状态日期
    ,fundstatus varchar2(2) -- 基金状态0：可申购赎回1：发行中4：停止申购赎回5：停止申购6：停止赎回8：基金终止9：封闭期
    ,convertstatus varchar2(2) -- 基金转换状态
    ,investplanstatus varchar2(2) -- 定投状态
    ,uptdatetime varchar2(30) -- 更新日期
    ,reserve1 varchar2(75) -- 备用字段1
    ,reserve2 varchar2(75) -- 备用字段2
    ,reserve3 varchar2(150) -- 备用字段3
    ,reserve4 varchar2(150) -- 备用字段4
    ,reserve5 varchar2(375) -- 备用字段5
    ,reserve6 varchar2(375) -- 备用字段6
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
grant select on ${iol_schema}.mpcs_a92fundmarket to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92fundmarket to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92fundmarket to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92fundmarket to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92fundmarket is '基金行情状态表';
comment on column ${iol_schema}.mpcs_a92fundmarket.paysys is '服务方简称';
comment on column ${iol_schema}.mpcs_a92fundmarket.instid is '接入商户号';
comment on column ${iol_schema}.mpcs_a92fundmarket.navdate is '净值日期';
comment on column ${iol_schema}.mpcs_a92fundmarket.fundcode is '基金代码';
comment on column ${iol_schema}.mpcs_a92fundmarket.nav is '单位净值';
comment on column ${iol_schema}.mpcs_a92fundmarket.accumulatednav is '累计净值';
comment on column ${iol_schema}.mpcs_a92fundmarket.returnday is '日涨幅';
comment on column ${iol_schema}.mpcs_a92fundmarket.unityield is '万份收益';
comment on column ${iol_schema}.mpcs_a92fundmarket.yearlyroe is '七日年化收益率';
comment on column ${iol_schema}.mpcs_a92fundmarket.statusdate is '状态日期';
comment on column ${iol_schema}.mpcs_a92fundmarket.fundstatus is '基金状态0：可申购赎回1：发行中4：停止申购赎回5：停止申购6：停止赎回8：基金终止9：封闭期';
comment on column ${iol_schema}.mpcs_a92fundmarket.convertstatus is '基金转换状态';
comment on column ${iol_schema}.mpcs_a92fundmarket.investplanstatus is '定投状态';
comment on column ${iol_schema}.mpcs_a92fundmarket.uptdatetime is '更新日期';
comment on column ${iol_schema}.mpcs_a92fundmarket.reserve1 is '备用字段1';
comment on column ${iol_schema}.mpcs_a92fundmarket.reserve2 is '备用字段2';
comment on column ${iol_schema}.mpcs_a92fundmarket.reserve3 is '备用字段3';
comment on column ${iol_schema}.mpcs_a92fundmarket.reserve4 is '备用字段4';
comment on column ${iol_schema}.mpcs_a92fundmarket.reserve5 is '备用字段5';
comment on column ${iol_schema}.mpcs_a92fundmarket.reserve6 is '备用字段6';
comment on column ${iol_schema}.mpcs_a92fundmarket.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a92fundmarket.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a92fundmarket.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a92fundmarket.etl_timestamp is 'ETL处理时间戳';
