/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_p_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_p_type
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_p_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_p_type(
    id number(22) -- 产品分类id
    ,a_type varchar2(30) -- 资产类型
    ,p_type varchar2(30) -- 产品类型
    ,p_type_name varchar2(150) -- 产品类型名称
    ,is_auto_prft number(22) -- 是否自动息差；1：是，0：否
    ,is_allow_delay number(22) -- 是否允许延迟到期；    0:自动确认    1:允许延期手动确认    2:不允许延期手动确认
    ,amort_method number(22) -- 摊销算法；  -1:不摊销，  0:直线摊销，  1:到期收益率算法，  使用交易全价，  2:到期收益率算法，  使用条款全价，  3:平价收益率算法，  使用交易全价，  4:平价收益率算法，  使用条款全价，  5:日实际利率摊销算法，  使用公式计算的日摊销利息收入，  6:日实际利率摊销算法，  使用公式计算的日实际利息收入，  7:年实际利率摊销算法，  使用公式计算的日摊销利息收入，  8:年实际利率摊销算法，  使用公式计算的日实际利息收入，  9:到期收益率算法，每天贴现，使用交易全价，  10:到期收益率算法，每天贴现，使用条款全价，  11:平价收益率算法，每天贴现，使用交易全价，  12:平价收益率算法，每天贴现，使用条款全价
    ,amort_method_name varchar2(150) -- 摊销算法名称
    ,is_tprice number(22) -- 是否估值
    ,fv_type number(22) -- 估值类型；    0:不估值，    1:手工维护优先，次之外部导入，最后系统定价,    2:手工维护优先，而后系统定价，最后外部导入    3:手工维护优先，而后外部导入，不使用系统定价
    ,is_allow_withdraw number(4,0) -- 是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
    ,is_allow_accrue number(4,0) -- 是否允许计提
    ,is_allow_receiveai number(4,0) -- 是否允许随时收息
    ,is_auto_overdue number(4,0) -- 是否自动逾期;1:是，0：否
    ,pending_account varchar2(45) -- 挂账账户
    ,pending_account_name varchar2(45) -- 挂账账户户名
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
grant select on ${iol_schema}.ibms_ttrd_p_type to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_p_type to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_p_type to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_p_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_p_type is '资产类型表';
comment on column ${iol_schema}.ibms_ttrd_p_type.id is '产品分类id';
comment on column ${iol_schema}.ibms_ttrd_p_type.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_p_type.p_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_p_type.p_type_name is '产品类型名称';
comment on column ${iol_schema}.ibms_ttrd_p_type.is_auto_prft is '是否自动息差；1：是，0：否';
comment on column ${iol_schema}.ibms_ttrd_p_type.is_allow_delay is '是否允许延迟到期；    0:自动确认    1:允许延期手动确认    2:不允许延期手动确认';
comment on column ${iol_schema}.ibms_ttrd_p_type.amort_method is '摊销算法；  -1:不摊销，  0:直线摊销，  1:到期收益率算法，  使用交易全价，  2:到期收益率算法，  使用条款全价，  3:平价收益率算法，  使用交易全价，  4:平价收益率算法，  使用条款全价，  5:日实际利率摊销算法，  使用公式计算的日摊销利息收入，  6:日实际利率摊销算法，  使用公式计算的日实际利息收入，  7:年实际利率摊销算法，  使用公式计算的日摊销利息收入，  8:年实际利率摊销算法，  使用公式计算的日实际利息收入，  9:到期收益率算法，每天贴现，使用交易全价，  10:到期收益率算法，每天贴现，使用条款全价，  11:平价收益率算法，每天贴现，使用交易全价，  12:平价收益率算法，每天贴现，使用条款全价';
comment on column ${iol_schema}.ibms_ttrd_p_type.amort_method_name is '摊销算法名称';
comment on column ${iol_schema}.ibms_ttrd_p_type.is_tprice is '是否估值';
comment on column ${iol_schema}.ibms_ttrd_p_type.fv_type is '估值类型；    0:不估值，    1:手工维护优先，次之外部导入，最后系统定价,    2:手工维护优先，而后系统定价，最后外部导入    3:手工维护优先，而后外部导入，不使用系统定价';
comment on column ${iol_schema}.ibms_ttrd_p_type.is_allow_withdraw is '是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）';
comment on column ${iol_schema}.ibms_ttrd_p_type.is_allow_accrue is '是否允许计提';
comment on column ${iol_schema}.ibms_ttrd_p_type.is_allow_receiveai is '是否允许随时收息';
comment on column ${iol_schema}.ibms_ttrd_p_type.is_auto_overdue is '是否自动逾期;1:是，0：否';
comment on column ${iol_schema}.ibms_ttrd_p_type.pending_account is '挂账账户';
comment on column ${iol_schema}.ibms_ttrd_p_type.pending_account_name is '挂账账户户名';
comment on column ${iol_schema}.ibms_ttrd_p_type.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_p_type.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_p_type.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_p_type.etl_timestamp is 'ETL处理时间戳';
