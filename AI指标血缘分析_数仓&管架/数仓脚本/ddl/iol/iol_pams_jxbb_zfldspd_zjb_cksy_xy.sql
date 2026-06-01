/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zfldspd_zjb_cksy_xy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khh varchar2(90) -- 客户号
    ,cksybl number(25,4) -- 存款收益比例(%)
    ,khmc varchar2(1500) -- 对应客户名称
    ,jbr number(22) -- 经办人
    ,cjrq number(22) -- 创建日期
    ,jlsj timestamp -- 记录时间
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
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy is '绩效报表_总分联动审批单_资金部_存款收益比例';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.cksybl is '存款收益比例(%)';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.khmc is '对应客户名称';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.jbr is '经办人';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.cjrq is '创建日期';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.jlsj is '记录时间';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxbb_zfldspd_zjb_cksy_xy.etl_timestamp is 'ETL处理时间戳';
