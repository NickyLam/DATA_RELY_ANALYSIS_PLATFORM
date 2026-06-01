/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_dr_rateinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_dr_rateinfo
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_dr_rateinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_dr_rateinfo(
    lsh varchar2(30) -- 评级流水号，每次调用债项评级引擎都会生出一个新的评级流水号
    ,caldate varchar2(10) -- 债项评级计算日期，格式yyyy-mm-dd
    ,custid varchar2(30) -- 授信客户编号
    ,calobj varchar2(5) -- 计算层面：0-额度层面、1-合同层面、2-借据层面
    ,calalg varchar2(5) -- 债项评级算法：0-初级法、1-过渡期
    ,disalg varchar2(5) -- 缓释分配算法：0-比例法、1-消耗法
    ,allcover varchar2(5) -- 抵质押品与保证是否同时覆盖：0-是、1-否
    ,ctype varchar2(5) -- C%作用方式：0-直接作用、1-折扣系数方式作用
    ,source varchar2(5) -- 调用债项评级计算引擎的方式：0-单一计算、1-夜间批量、2-押品压力测试
    ,pdchoose varchar2(5) -- PD对象使用开关，0-使用债项的PD对象，1-不使用债项的PD对象
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nrrs_dr_rateinfo to ${iml_schema};
grant select on ${iol_schema}.nrrs_dr_rateinfo to ${icl_schema};
grant select on ${iol_schema}.nrrs_dr_rateinfo to ${idl_schema};

-- comment
comment on table ${iol_schema}.nrrs_dr_rateinfo is '存储债项评级计算情况总表';
comment on column ${iol_schema}.nrrs_dr_rateinfo.lsh is '评级流水号，每次调用债项评级引擎都会生出一个新的评级流水号';
comment on column ${iol_schema}.nrrs_dr_rateinfo.caldate is '债项评级计算日期，格式yyyy-mm-dd';
comment on column ${iol_schema}.nrrs_dr_rateinfo.custid is '授信客户编号';
comment on column ${iol_schema}.nrrs_dr_rateinfo.calobj is '计算层面：0-额度层面、1-合同层面、2-借据层面';
comment on column ${iol_schema}.nrrs_dr_rateinfo.calalg is '债项评级算法：0-初级法、1-过渡期';
comment on column ${iol_schema}.nrrs_dr_rateinfo.disalg is '缓释分配算法：0-比例法、1-消耗法';
comment on column ${iol_schema}.nrrs_dr_rateinfo.allcover is '抵质押品与保证是否同时覆盖：0-是、1-否';
comment on column ${iol_schema}.nrrs_dr_rateinfo.ctype is 'C%作用方式：0-直接作用、1-折扣系数方式作用';
comment on column ${iol_schema}.nrrs_dr_rateinfo.source is '调用债项评级计算引擎的方式：0-单一计算、1-夜间批量、2-押品压力测试';
comment on column ${iol_schema}.nrrs_dr_rateinfo.pdchoose is 'PD对象使用开关，0-使用债项的PD对象，1-不使用债项的PD对象';
comment on column ${iol_schema}.nrrs_dr_rateinfo.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_dr_rateinfo.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_dr_rateinfo.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_dr_rateinfo.etl_timestamp is 'ETL处理时间戳';
