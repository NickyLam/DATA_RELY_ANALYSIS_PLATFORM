/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_gdpronsrsqssxx_body_djnsrxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,scjydz varchar2(4000) -- 生产经营地址
    ,zzlx_dm varchar2(4000) -- 执照类型代码
    ,zgswskfj_dm varchar2(4000) -- 主管税务所（科、分局）代码
    ,gdghlx_dm varchar2(4000) -- 国地管户类型代码
    ,scjydzxzqhszmc varchar2(4000) -- 生产经营地址行政区划数字名称
    ,hymc varchar2(4000) -- 行业名称
    ,djnsrxx varchar2(4000) -- 关联标签
    ,nsrztmc varchar2(4000) -- 纳税人状态代码
    ,zcdzxzqhsz_dm varchar2(4000) -- 注册地址行政区划数字代码
    ,zzlxmc varchar2(4000) -- 执照类型名称
    ,kyslrq varchar2(4000) -- 开业设立日期
    ,dwlsgxmc varchar2(4000) -- 单位隶属关系名称
    ,fddbrxm varchar2(4000) -- 法定代表人姓名
    ,fddbrsfzjlx_dm varchar2(4000) -- 法定代表人身份证件类型代码
    ,ssgly_dm varchar2(4000) -- 税收管理员代码
    ,gdslx_dm varchar2(4000) -- 国地税类型代码
    ,djzclxmc varchar2(4000) -- 登记注册类型名称
    ,zcdz varchar2(4000) -- 注册地址
    ,djxh varchar2(4000) -- 登记序号
    ,hy_dm varchar2(4000) -- 行业代码
    ,ssglymc varchar2(4000) -- 税收管理员名称
    ,zcdzxzqhszmc varchar2(4000) -- 注册地址行政区划数字名称
    ,shxydm varchar2(4000) -- 社会信用代码
    ,nsrsbh varchar2(4000) -- 税务代理人纳税人识别号
    ,gdslxmc varchar2(4000) -- 国地税类型名称
    ,fddbrsfzjlxmc varchar2(4000) -- 法定代表人身份证件类型名称
    ,djrq varchar2(4000) -- 登记日期
    ,djjgmc varchar2(4000) -- 登记机关名称
    ,djjg_dm varchar2(4000) -- 登记机关代码
    ,nsrzt_dm varchar2(4000) -- 纳税人状态代码
    ,zzhm varchar2(4000) -- 证照编号
    ,djzclx_dm varchar2(4000) -- 登记注册类型代码
    ,ssdabh varchar2(4000) -- 税收档案编号
    ,nsrmc varchar2(4000) -- 纳税人名称
    ,zzjg_dm varchar2(4000) -- 组织机构代码
    ,zgswskfjmc varchar2(4000) -- 主管税务所（科、分局）名称
    ,jdxz_dm varchar2(4000) -- 街道乡镇代码
    ,fddbrsfzjhm varchar2(4000) -- 法定代表人身份证号码
    ,zzjgmc varchar2(4000) -- 组织机构名称
    ,zgswj_dm varchar2(4000) -- 主管税务局代码
    ,jdxzmc varchar2(4000) -- 街道乡镇名称
    ,zgswjmc varchar2(4000) -- 主管税务局名称
    ,dwlsgx_dm varchar2(4000) -- 单位隶属关系代码
    ,gdghlxmc varchar2(4000) -- 国地管户类型名称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx to ${iml_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx to ${icl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx to ${idl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx is '税务';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.scjydz is '生产经营地址';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zzlx_dm is '执照类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zgswskfj_dm is '主管税务所（科、分局）代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.gdghlx_dm is '国地管户类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.scjydzxzqhszmc is '生产经营地址行政区划数字名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.hymc is '行业名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.djnsrxx is '关联标签';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.nsrztmc is '纳税人状态代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zcdzxzqhsz_dm is '注册地址行政区划数字代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zzlxmc is '执照类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.kyslrq is '开业设立日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.dwlsgxmc is '单位隶属关系名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.fddbrxm is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.fddbrsfzjlx_dm is '法定代表人身份证件类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.ssgly_dm is '税收管理员代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.gdslx_dm is '国地税类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.djzclxmc is '登记注册类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zcdz is '注册地址';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.djxh is '登记序号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.hy_dm is '行业代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.ssglymc is '税收管理员名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zcdzxzqhszmc is '注册地址行政区划数字名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.shxydm is '社会信用代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.nsrsbh is '税务代理人纳税人识别号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.gdslxmc is '国地税类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.fddbrsfzjlxmc is '法定代表人身份证件类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.djrq is '登记日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.djjgmc is '登记机关名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.djjg_dm is '登记机关代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.nsrzt_dm is '纳税人状态代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zzhm is '证照编号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.djzclx_dm is '登记注册类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.ssdabh is '税收档案编号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.nsrmc is '纳税人名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zzjg_dm is '组织机构代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zgswskfjmc is '主管税务所（科、分局）名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.jdxz_dm is '街道乡镇代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.fddbrsfzjhm is '法定代表人身份证号码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zzjgmc is '组织机构名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zgswj_dm is '主管税务局代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.jdxzmc is '街道乡镇名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.zgswjmc is '主管税务局名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.dwlsgx_dm is '单位隶属关系代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.gdghlxmc is '国地管户类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx.etl_timestamp is 'ETL处理时间戳';
