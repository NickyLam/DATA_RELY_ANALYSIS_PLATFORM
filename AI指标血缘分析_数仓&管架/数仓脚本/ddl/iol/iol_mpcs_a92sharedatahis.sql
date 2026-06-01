/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92sharedatahis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92sharedatahis
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92sharedatahis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92sharedatahis(
    paysys varchar2(15) -- 服务方简称
    ,instid varchar2(15) -- 接入商户号
    ,shareid varchar2(96) -- 份额id
    ,brokeruserid varchar2(96) -- 用户账户id
    ,accountid varchar2(96) -- 盈米账户id
    ,paymentmethodid varchar2(96) -- 支付方式id
    ,fundcode varchar2(45) -- 基金代码
    ,sharetypes varchar2(2) -- 收费类型
    ,totalshare number(17,4) -- 总份额
    ,freezeshare number(17,4) -- 冻结份额
    ,unpaidincome number(17,4) -- 未付收益
    ,dividendmethod varchar2(2) -- 分红方式
    ,remark varchar2(383) -- 备注
    ,pocode varchar2(45) -- 组合代码
    ,newincome number(17,4) -- 最新收益
    ,accumulateincome number(17,4) -- 累计收益
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
grant select on ${iol_schema}.mpcs_a92sharedatahis to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92sharedatahis to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92sharedatahis to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92sharedatahis to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92sharedatahis is '基金份额表';
comment on column ${iol_schema}.mpcs_a92sharedatahis.paysys is '服务方简称';
comment on column ${iol_schema}.mpcs_a92sharedatahis.instid is '接入商户号';
comment on column ${iol_schema}.mpcs_a92sharedatahis.shareid is '份额id';
comment on column ${iol_schema}.mpcs_a92sharedatahis.brokeruserid is '用户账户id';
comment on column ${iol_schema}.mpcs_a92sharedatahis.accountid is '盈米账户id';
comment on column ${iol_schema}.mpcs_a92sharedatahis.paymentmethodid is '支付方式id';
comment on column ${iol_schema}.mpcs_a92sharedatahis.fundcode is '基金代码';
comment on column ${iol_schema}.mpcs_a92sharedatahis.sharetypes is '收费类型';
comment on column ${iol_schema}.mpcs_a92sharedatahis.totalshare is '总份额';
comment on column ${iol_schema}.mpcs_a92sharedatahis.freezeshare is '冻结份额';
comment on column ${iol_schema}.mpcs_a92sharedatahis.unpaidincome is '未付收益';
comment on column ${iol_schema}.mpcs_a92sharedatahis.dividendmethod is '分红方式';
comment on column ${iol_schema}.mpcs_a92sharedatahis.remark is '备注';
comment on column ${iol_schema}.mpcs_a92sharedatahis.pocode is '组合代码';
comment on column ${iol_schema}.mpcs_a92sharedatahis.newincome is '最新收益';
comment on column ${iol_schema}.mpcs_a92sharedatahis.accumulateincome is '累计收益';
comment on column ${iol_schema}.mpcs_a92sharedatahis.uptdatetime is '更新日期';
comment on column ${iol_schema}.mpcs_a92sharedatahis.reserve1 is '备用字段1';
comment on column ${iol_schema}.mpcs_a92sharedatahis.reserve2 is '备用字段2';
comment on column ${iol_schema}.mpcs_a92sharedatahis.reserve3 is '备用字段3';
comment on column ${iol_schema}.mpcs_a92sharedatahis.reserve4 is '备用字段4';
comment on column ${iol_schema}.mpcs_a92sharedatahis.reserve5 is '备用字段5';
comment on column ${iol_schema}.mpcs_a92sharedatahis.reserve6 is '备用字段6';
comment on column ${iol_schema}.mpcs_a92sharedatahis.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a92sharedatahis.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a92sharedatahis.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a92sharedatahis.etl_timestamp is 'ETL处理时间戳';
