/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhd_glbglisbook_hsfile
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhd_glbglisbook_hsfile
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhd_glbglisbook_hsfile purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhd_glbglisbook_hsfile(
    systid varchar2(30) -- 系统代号
    ,acctdt varchar2(8) -- 账务日期
    ,brchcd varchar2(16) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,assis8 varchar2(30) -- 产品
    ,crcycd varchar2(3) -- 币种
    ,drtsam number(20,2) -- 借方本期发生额
    ,crtsam number(20,2) -- 贷方本期发生额
    ,drctbl number(20,2) -- 借方本期余额
    ,crctbl number(20,2) -- 贷方本期余额
    ,blncdn varchar2(1) -- 当前余额方向
    ,onlnbl number(20,2) -- 当前余额
    ,inputtime varchar2(30) -- 登记时间
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
grant select on ${iol_schema}.icms_lhd_glbglisbook_hsfile to ${iml_schema};
grant select on ${iol_schema}.icms_lhd_glbglisbook_hsfile to ${icl_schema};
grant select on ${iol_schema}.icms_lhd_glbglisbook_hsfile to ${idl_schema};
grant select on ${iol_schema}.icms_lhd_glbglisbook_hsfile to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhd_glbglisbook_hsfile is '联合贷推送核心科目余额对账文件数据信息表';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.systid is '系统代号';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.acctdt is '账务日期';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.brchcd is '账务机构编号';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.itemcd is '科目编号';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.assis8 is '产品';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.crcycd is '币种';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.drtsam is '借方本期发生额';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.crtsam is '贷方本期发生额';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.drctbl is '借方本期余额';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.crctbl is '贷方本期余额';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.blncdn is '当前余额方向';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.onlnbl is '当前余额';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.inputtime is '登记时间';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhd_glbglisbook_hsfile.etl_timestamp is 'ETL处理时间戳';
