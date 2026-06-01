/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_rpt_segment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_rpt_segment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_rpt_segment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_rpt_segment(
    serialno varchar2(64) -- 流水号
    ,repaydate date -- 还款日期
    ,payfrequencytype varchar2(36) -- 还款周期类型
    ,segtermid varchar2(64) -- 子还款方式
    ,segtodate date -- 区段结束日
    ,payfrequency number(28,6) -- 指定周期值
    ,termid varchar2(64) -- 还款方式
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,segfromdate date -- 区段起始日
    ,inputuserid varchar2(64) -- 登记人
    ,curterm number(22) -- 当前期数
    ,objecttype varchar2(64) -- 对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更
    ,payfrequencyunit varchar2(36) -- 指定周期单位
    ,inputorgid varchar2(64) -- 登记机构
    ,defaultdueday number(22) -- 默认还款日
    ,inputdate varchar2(64) -- 登记日期
    ,objectno varchar2(64) -- 对象编号
    ,segrptamount number(24,6) -- 指定金额
    ,corporgid varchar2(64) -- 法人机构编号
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
grant select on ${iol_schema}.icms_business_rpt_segment to ${iml_schema};
grant select on ${iol_schema}.icms_business_rpt_segment to ${icl_schema};
grant select on ${iol_schema}.icms_business_rpt_segment to ${idl_schema};
grant select on ${iol_schema}.icms_business_rpt_segment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_rpt_segment is '自定义还款信息表';
comment on column ${iol_schema}.icms_business_rpt_segment.serialno is '流水号';
comment on column ${iol_schema}.icms_business_rpt_segment.repaydate is '还款日期';
comment on column ${iol_schema}.icms_business_rpt_segment.payfrequencytype is '还款周期类型';
comment on column ${iol_schema}.icms_business_rpt_segment.segtermid is '子还款方式';
comment on column ${iol_schema}.icms_business_rpt_segment.segtodate is '区段结束日';
comment on column ${iol_schema}.icms_business_rpt_segment.payfrequency is '指定周期值';
comment on column ${iol_schema}.icms_business_rpt_segment.termid is '还款方式';
comment on column ${iol_schema}.icms_business_rpt_segment.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_business_rpt_segment.segfromdate is '区段起始日';
comment on column ${iol_schema}.icms_business_rpt_segment.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_rpt_segment.curterm is '当前期数';
comment on column ${iol_schema}.icms_business_rpt_segment.objecttype is '对象类型：BusinessPutout可用于出账，RPTChange可用于贷后还款方式变更';
comment on column ${iol_schema}.icms_business_rpt_segment.payfrequencyunit is '指定周期单位';
comment on column ${iol_schema}.icms_business_rpt_segment.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_rpt_segment.defaultdueday is '默认还款日';
comment on column ${iol_schema}.icms_business_rpt_segment.inputdate is '登记日期';
comment on column ${iol_schema}.icms_business_rpt_segment.objectno is '对象编号';
comment on column ${iol_schema}.icms_business_rpt_segment.segrptamount is '指定金额';
comment on column ${iol_schema}.icms_business_rpt_segment.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_business_rpt_segment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_rpt_segment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_rpt_segment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_rpt_segment.etl_timestamp is 'ETL处理时间戳';
