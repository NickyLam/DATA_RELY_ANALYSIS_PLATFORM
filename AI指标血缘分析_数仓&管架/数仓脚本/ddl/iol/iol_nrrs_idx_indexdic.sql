/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_idx_indexdic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_idx_indexdic
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_idx_indexdic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_idx_indexdic(
    indexcode varchar2(20) -- 指标编码
    ,indexname varchar2(500) -- 指标名称
    ,indextype varchar2(6) -- 指标类别
    ,indexcycle varchar2(6) -- 指标周期
    ,placedtable varchar2(30) -- 指标存放表
    ,placedfield varchar2(20) -- 指标值存放字段
    ,prikeynum number -- 指标主键个数
    ,prikey1 varchar2(20) -- 指标主键1
    ,prikey2 varchar2(20) -- 指标主键2
    ,prikey3 varchar2(20) -- 指标主键3
    ,prikey4 varchar2(20) -- 指标主键4
    ,prikey5 varchar2(20) -- 指标主键5
    ,summarizetype varchar2(6) -- 指标汇总方式
    ,algtype varchar2(6) -- 指标算法类别
    ,sourcetype varchar2(6) -- 指标来源类别
    ,state number -- 指标状态
    ,defaultmethod varchar2(6) -- 缺值处理方式
    ,units varchar2(6) -- 指标单位
    ,flag varchar2(1) -- 指标标志
    ,flaginfo varchar2(6) -- 指标定性相关信息
    ,fraudtype varchar2(6) -- 反欺诈类型
    ,isimportant varchar2(1) -- 是否主要指标
    ,trends varchar2(1) -- 趋势
    ,indexsubtype varchar2(10) -- 指标细类
    ,indexlevel number -- 指标层次
    ,istmpindex varchar2(1) -- 是否临时指标
    ,sampletype varchar2(30) -- 样本类型
    ,remark varchar2(500) -- 备注
    ,nounsuper varchar2(20) -- 对应字典编号
    ,debtadjustlfid varchar2(20) -- 
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
grant select on ${iol_schema}.nrrs_idx_indexdic to ${iml_schema};
grant select on ${iol_schema}.nrrs_idx_indexdic to ${icl_schema};
grant select on ${iol_schema}.nrrs_idx_indexdic to ${idl_schema};

-- comment
comment on table ${iol_schema}.nrrs_idx_indexdic is '';
comment on column ${iol_schema}.nrrs_idx_indexdic.indexcode is '指标编码';
comment on column ${iol_schema}.nrrs_idx_indexdic.indexname is '指标名称';
comment on column ${iol_schema}.nrrs_idx_indexdic.indextype is '指标类别';
comment on column ${iol_schema}.nrrs_idx_indexdic.indexcycle is '指标周期';
comment on column ${iol_schema}.nrrs_idx_indexdic.placedtable is '指标存放表';
comment on column ${iol_schema}.nrrs_idx_indexdic.placedfield is '指标值存放字段';
comment on column ${iol_schema}.nrrs_idx_indexdic.prikeynum is '指标主键个数';
comment on column ${iol_schema}.nrrs_idx_indexdic.prikey1 is '指标主键1';
comment on column ${iol_schema}.nrrs_idx_indexdic.prikey2 is '指标主键2';
comment on column ${iol_schema}.nrrs_idx_indexdic.prikey3 is '指标主键3';
comment on column ${iol_schema}.nrrs_idx_indexdic.prikey4 is '指标主键4';
comment on column ${iol_schema}.nrrs_idx_indexdic.prikey5 is '指标主键5';
comment on column ${iol_schema}.nrrs_idx_indexdic.summarizetype is '指标汇总方式';
comment on column ${iol_schema}.nrrs_idx_indexdic.algtype is '指标算法类别';
comment on column ${iol_schema}.nrrs_idx_indexdic.sourcetype is '指标来源类别';
comment on column ${iol_schema}.nrrs_idx_indexdic.state is '指标状态';
comment on column ${iol_schema}.nrrs_idx_indexdic.defaultmethod is '缺值处理方式';
comment on column ${iol_schema}.nrrs_idx_indexdic.units is '指标单位';
comment on column ${iol_schema}.nrrs_idx_indexdic.flag is '指标标志';
comment on column ${iol_schema}.nrrs_idx_indexdic.flaginfo is '指标定性相关信息';
comment on column ${iol_schema}.nrrs_idx_indexdic.fraudtype is '反欺诈类型';
comment on column ${iol_schema}.nrrs_idx_indexdic.isimportant is '是否主要指标';
comment on column ${iol_schema}.nrrs_idx_indexdic.trends is '趋势';
comment on column ${iol_schema}.nrrs_idx_indexdic.indexsubtype is '指标细类';
comment on column ${iol_schema}.nrrs_idx_indexdic.indexlevel is '指标层次';
comment on column ${iol_schema}.nrrs_idx_indexdic.istmpindex is '是否临时指标';
comment on column ${iol_schema}.nrrs_idx_indexdic.sampletype is '样本类型';
comment on column ${iol_schema}.nrrs_idx_indexdic.remark is '备注';
comment on column ${iol_schema}.nrrs_idx_indexdic.nounsuper is '对应字典编号';
comment on column ${iol_schema}.nrrs_idx_indexdic.debtadjustlfid is '';
comment on column ${iol_schema}.nrrs_idx_indexdic.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_idx_indexdic.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_idx_indexdic.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_idx_indexdic.etl_timestamp is 'ETL处理时间戳';
