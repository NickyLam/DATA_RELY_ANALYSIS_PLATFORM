/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icrw_t_sys_org
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icrw_t_sys_org
whenever sqlerror continue none;
drop table ${iol_schema}.icrw_t_sys_org purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icrw_t_sys_org(
    org_id varchar2(864) -- 机构ID
    ,org_name varchar2(2700) -- 机构名称
    ,org_abbr varchar2(2700) -- 机构简称
    ,brch_id varchar2(864) -- 分行机构
    ,brch_name varchar2(2700) -- 分行机构名称
    ,parent_org_id varchar2(864) -- 上级机构ID
    ,org_level number(22) -- 机构级次
    ,org_level_code varchar2(2700) -- 机构级次码
    ,sort_no number(22) -- 排序号
    ,remark varchar2(4000) -- 备注
    ,ver number(22) -- 数据版本
    ,org_type varchar2(108) -- 机构类型,0001=部门、0002=机构、0003=村镇银行、0010=自定义
    ,short_name varchar2(2700) -- 机构简称
    ,is_law_org varchar2(27) -- 是否法人联社,1=是、0=否
    ,law_org_id varchar2(864) -- 所属法人机构号
    ,tel varchar2(540) -- 部门机构电话
    ,addr varchar2(3240) -- 部门机构地址
    ,update_time varchar2(378) -- 更新时间
    ,org_lng varchar2(864) -- 经度
    ,org_lat varchar2(864) -- 纬度
    ,index_is_show varchar2(270) -- 是否在指标展示
    ,is_show varchar2(27) -- 是否展示
    ,is_statis varchar2(54) -- 统计标识，1=总分支统计节点，2=团队，0非统计节点
    ,is_bill varchar2(27) -- 是否是账务机构
    ,is_rank varchar2(27) -- 是否参与投金部指标排行
    ,org_status varchar2(135) -- 机构状态
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
grant select on ${iol_schema}.icrw_t_sys_org to ${iml_schema};
grant select on ${iol_schema}.icrw_t_sys_org to ${icl_schema};
grant select on ${iol_schema}.icrw_t_sys_org to ${idl_schema};
grant select on ${iol_schema}.icrw_t_sys_org to ${iel_schema};

-- comment
comment on table ${iol_schema}.icrw_t_sys_org is '机构表';
comment on column ${iol_schema}.icrw_t_sys_org.org_id is '机构ID';
comment on column ${iol_schema}.icrw_t_sys_org.org_name is '机构名称';
comment on column ${iol_schema}.icrw_t_sys_org.org_abbr is '机构简称';
comment on column ${iol_schema}.icrw_t_sys_org.brch_id is '分行机构';
comment on column ${iol_schema}.icrw_t_sys_org.brch_name is '分行机构名称';
comment on column ${iol_schema}.icrw_t_sys_org.parent_org_id is '上级机构ID';
comment on column ${iol_schema}.icrw_t_sys_org.org_level is '机构级次';
comment on column ${iol_schema}.icrw_t_sys_org.org_level_code is '机构级次码';
comment on column ${iol_schema}.icrw_t_sys_org.sort_no is '排序号';
comment on column ${iol_schema}.icrw_t_sys_org.remark is '备注';
comment on column ${iol_schema}.icrw_t_sys_org.ver is '数据版本';
comment on column ${iol_schema}.icrw_t_sys_org.org_type is '机构类型,0001=部门、0002=机构、0003=村镇银行、0010=自定义';
comment on column ${iol_schema}.icrw_t_sys_org.short_name is '机构简称';
comment on column ${iol_schema}.icrw_t_sys_org.is_law_org is '是否法人联社,1=是、0=否';
comment on column ${iol_schema}.icrw_t_sys_org.law_org_id is '所属法人机构号';
comment on column ${iol_schema}.icrw_t_sys_org.tel is '部门机构电话';
comment on column ${iol_schema}.icrw_t_sys_org.addr is '部门机构地址';
comment on column ${iol_schema}.icrw_t_sys_org.update_time is '更新时间';
comment on column ${iol_schema}.icrw_t_sys_org.org_lng is '经度';
comment on column ${iol_schema}.icrw_t_sys_org.org_lat is '纬度';
comment on column ${iol_schema}.icrw_t_sys_org.index_is_show is '是否在指标展示';
comment on column ${iol_schema}.icrw_t_sys_org.is_show is '是否展示';
comment on column ${iol_schema}.icrw_t_sys_org.is_statis is '统计标识，1=总分支统计节点，2=团队，0非统计节点';
comment on column ${iol_schema}.icrw_t_sys_org.is_bill is '是否是账务机构';
comment on column ${iol_schema}.icrw_t_sys_org.is_rank is '是否参与投金部指标排行';
comment on column ${iol_schema}.icrw_t_sys_org.org_status is '机构状态';
comment on column ${iol_schema}.icrw_t_sys_org.start_dt is '开始时间';
comment on column ${iol_schema}.icrw_t_sys_org.end_dt is '结束时间';
comment on column ${iol_schema}.icrw_t_sys_org.id_mark is '增删标志';
comment on column ${iol_schema}.icrw_t_sys_org.etl_timestamp is 'ETL处理时间戳';
