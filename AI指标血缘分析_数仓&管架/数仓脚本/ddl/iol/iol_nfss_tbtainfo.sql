/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbtainfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbtainfo
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbtainfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbtainfo(
    ta_code varchar2(18) -- ta代码
    ,ta_shortname varchar2(30) -- ta简称
    ,ta_name varchar2(90) -- ta名称
    ,comp_mode varchar2(2) -- 对账模式
    ,templet varchar2(30) -- 接口模板
    ,open_time number(22,0) -- 开市时间
    ,close_time number(22,0) -- 闭市时间
    ,status varchar2(2) -- ta状态
    ,prd_type varchar2(2) -- 产品类别
    ,sum_flag varchar2(2) -- 确认汇总标志
    ,muti_acc varchar2(2) -- 多账号模式
    ,clear_type varchar2(2) -- 清算方式
    ,real_cfm_flag varchar2(2) -- ta类交易是否实时确认
    ,sub_deal_mode varchar2(2) -- 认购确认是否解冻扣款
    ,cfm_fail_intere_in varchar2(2) -- 募集失败确认金额里面包含利息
    ,host_check_date number(22,0) -- 主机对帐日期
    ,first_invest_flags varchar2(90) -- 首次投资控制标识
    ,clear_table_flag varchar2(2) -- 清算是否使用独立表
    ,control_flag varchar2(512) -- bta参数控制位#
    ,reserve1 varchar2(375) -- 保留域1
    ,reserve2 varchar2(375) -- 保留域2
    ,reserve3 varchar2(375) -- 保留域3
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
grant select on ${iol_schema}.nfss_tbtainfo to ${iml_schema};
grant select on ${iol_schema}.nfss_tbtainfo to ${icl_schema};
grant select on ${iol_schema}.nfss_tbtainfo to ${idl_schema};
grant select on ${iol_schema}.nfss_tbtainfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbtainfo is 'TA信息表';
comment on column ${iol_schema}.nfss_tbtainfo.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbtainfo.ta_shortname is 'ta简称';
comment on column ${iol_schema}.nfss_tbtainfo.ta_name is 'ta名称';
comment on column ${iol_schema}.nfss_tbtainfo.comp_mode is '对账模式';
comment on column ${iol_schema}.nfss_tbtainfo.templet is '接口模板';
comment on column ${iol_schema}.nfss_tbtainfo.open_time is '开市时间';
comment on column ${iol_schema}.nfss_tbtainfo.close_time is '闭市时间';
comment on column ${iol_schema}.nfss_tbtainfo.status is 'ta状态';
comment on column ${iol_schema}.nfss_tbtainfo.prd_type is '产品类别';
comment on column ${iol_schema}.nfss_tbtainfo.sum_flag is '确认汇总标志';
comment on column ${iol_schema}.nfss_tbtainfo.muti_acc is '多账号模式';
comment on column ${iol_schema}.nfss_tbtainfo.clear_type is '清算方式';
comment on column ${iol_schema}.nfss_tbtainfo.real_cfm_flag is 'ta类交易是否实时确认';
comment on column ${iol_schema}.nfss_tbtainfo.sub_deal_mode is '认购确认是否解冻扣款';
comment on column ${iol_schema}.nfss_tbtainfo.cfm_fail_intere_in is '募集失败确认金额里面包含利息';
comment on column ${iol_schema}.nfss_tbtainfo.host_check_date is '主机对帐日期';
comment on column ${iol_schema}.nfss_tbtainfo.first_invest_flags is '首次投资控制标识';
comment on column ${iol_schema}.nfss_tbtainfo.clear_table_flag is '清算是否使用独立表';
comment on column ${iol_schema}.nfss_tbtainfo.control_flag is 'bta参数控制位#';
comment on column ${iol_schema}.nfss_tbtainfo.reserve1 is '保留域1';
comment on column ${iol_schema}.nfss_tbtainfo.reserve2 is '保留域2';
comment on column ${iol_schema}.nfss_tbtainfo.reserve3 is '保留域3';
comment on column ${iol_schema}.nfss_tbtainfo.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbtainfo.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbtainfo.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbtainfo.etl_timestamp is 'ETL处理时间戳';
