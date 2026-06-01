/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_khdx_hy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_khdx_hy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_khdx_hy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khdx_hy(
    khdxdh number(22,0) -- 考核对象代号
    ,hydh varchar2(18) -- 行员代号
    ,hymc varchar2(150) -- 行员名称
    ,xl varchar2(3) -- 学历
    ,lxdh varchar2(45) -- 联系电话
    ,sfz varchar2(38) -- 身份证号码
    ,yxrybz varchar2(2) -- 营销人员标志
    ,xnhybz varchar2(2) -- 虚拟行员标志
    ,dlmc varchar2(18) -- 登录名称
    ,dlmm varchar2(150) -- 登录密码
    ,aqjb varchar2(2) -- 安全级别
    ,zxzt varchar2(2) -- 注销状态
    ,scdl varchar2(2) -- 首次登陆
    ,zpxx varchar2(150) -- 照片信息
    ,czybh varchar2(18) -- 操作员编号
    ,zxrq number(22,0) -- 注销日期
    ,csrq number(22,0) -- 出生日期
    ,gzrq number(22,0) -- 工作日期
    ,rhrq number(22,0) -- 入行日期
    ,fgbz varchar2(2) -- 风格标志
    ,pxbz number(22,0) -- 排序标志
    ,xgmmrq varchar2(30) -- 修改密码日期
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
grant select on ${iol_schema}.pams_khdx_hy to ${iml_schema};
grant select on ${iol_schema}.pams_khdx_hy to ${icl_schema};
grant select on ${iol_schema}.pams_khdx_hy to ${idl_schema};
grant select on ${iol_schema}.pams_khdx_hy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_khdx_hy is '考核对象-行员';
comment on column ${iol_schema}.pams_khdx_hy.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_khdx_hy.hydh is '行员代号';
comment on column ${iol_schema}.pams_khdx_hy.hymc is '行员名称';
comment on column ${iol_schema}.pams_khdx_hy.xl is '学历';
comment on column ${iol_schema}.pams_khdx_hy.lxdh is '联系电话';
comment on column ${iol_schema}.pams_khdx_hy.sfz is '身份证号码';
comment on column ${iol_schema}.pams_khdx_hy.yxrybz is '营销人员标志';
comment on column ${iol_schema}.pams_khdx_hy.xnhybz is '虚拟行员标志';
comment on column ${iol_schema}.pams_khdx_hy.dlmc is '登录名称';
comment on column ${iol_schema}.pams_khdx_hy.dlmm is '登录密码';
comment on column ${iol_schema}.pams_khdx_hy.aqjb is '安全级别';
comment on column ${iol_schema}.pams_khdx_hy.zxzt is '注销状态';
comment on column ${iol_schema}.pams_khdx_hy.scdl is '首次登陆';
comment on column ${iol_schema}.pams_khdx_hy.zpxx is '照片信息';
comment on column ${iol_schema}.pams_khdx_hy.czybh is '操作员编号';
comment on column ${iol_schema}.pams_khdx_hy.zxrq is '注销日期';
comment on column ${iol_schema}.pams_khdx_hy.csrq is '出生日期';
comment on column ${iol_schema}.pams_khdx_hy.gzrq is '工作日期';
comment on column ${iol_schema}.pams_khdx_hy.rhrq is '入行日期';
comment on column ${iol_schema}.pams_khdx_hy.fgbz is '风格标志';
comment on column ${iol_schema}.pams_khdx_hy.pxbz is '排序标志';
comment on column ${iol_schema}.pams_khdx_hy.xgmmrq is '修改密码日期';
comment on column ${iol_schema}.pams_khdx_hy.start_dt is '开始时间';
comment on column ${iol_schema}.pams_khdx_hy.end_dt is '结束时间';
comment on column ${iol_schema}.pams_khdx_hy.id_mark is '增删标志';
comment on column ${iol_schema}.pams_khdx_hy.etl_timestamp is 'ETL处理时间戳';
