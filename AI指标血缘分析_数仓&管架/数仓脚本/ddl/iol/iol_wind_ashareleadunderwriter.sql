/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareleadunderwriter
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareleadunderwriter
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareleadunderwriter purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareleadunderwriter(
    object_id varchar2(150) -- 对象id
    ,s_info_windcode varchar2(60) -- wind代码
    ,s_lu_annissuedate varchar2(12) -- 发行公告日
    ,s_lu_issuedate varchar2(12) -- 发行日期
    ,s_lu_issuetype varchar2(2) -- 发行类型
    ,s_lu_totalissuecollection number(20,4) -- 募集资金合计(万元)
    ,s_lu_totalissueexpenses number(20,4) -- 发行费用合计(万元)
    ,s_lu_totaluderandsponefee number(20,4) -- 承销与保荐费用(万元)
    ,s_lu_number varchar2(3) -- 参与主承销商个数
    ,s_lu_name varchar2(150) -- 参与主承销商名称
    ,s_lu_institype varchar2(60) -- 主承销商类型
    ,s_lu_aux_type varchar2(60) -- 辅助类型
    ,s_info_compcode varchar2(60) -- 主承销商id
    ,all_lu varchar2(4000) -- 全部参与主承销商名称
    ,meeting_dt varchar2(12) -- 发审委会议日期
    ,pass_dt varchar2(12) -- 发审委通过公告日
    ,s_info_listdate varchar2(12) -- 上市日期
    ,type varchar2(60) -- 发行类型
    ,netcollection number(20,4) -- 募资净额合计(万元)
    ,avg_totalcoll number(20,4) -- 募集总额算术平均 (万元)
    ,avg_netcoll number(20,4) -- 募资净额算术平均 (万元)
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_ashareleadunderwriter to ${iml_schema};
grant select on ${iol_schema}.wind_ashareleadunderwriter to ${icl_schema};
grant select on ${iol_schema}.wind_ashareleadunderwriter to ${idl_schema};
grant select on ${iol_schema}.wind_ashareleadunderwriter to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareleadunderwriter is '中国A股发行主承销商';
comment on column ${iol_schema}.wind_ashareleadunderwriter.object_id is '对象id';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_info_windcode is 'wind代码';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_annissuedate is '发行公告日';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_issuedate is '发行日期';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_issuetype is '发行类型';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_totalissuecollection is '募集资金合计(万元)';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_totalissueexpenses is '发行费用合计(万元)';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_totaluderandsponefee is '承销与保荐费用(万元)';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_number is '参与主承销商个数';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_name is '参与主承销商名称';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_institype is '主承销商类型';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_lu_aux_type is '辅助类型';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_info_compcode is '主承销商id';
comment on column ${iol_schema}.wind_ashareleadunderwriter.all_lu is '全部参与主承销商名称';
comment on column ${iol_schema}.wind_ashareleadunderwriter.meeting_dt is '发审委会议日期';
comment on column ${iol_schema}.wind_ashareleadunderwriter.pass_dt is '发审委通过公告日';
comment on column ${iol_schema}.wind_ashareleadunderwriter.s_info_listdate is '上市日期';
comment on column ${iol_schema}.wind_ashareleadunderwriter.type is '发行类型';
comment on column ${iol_schema}.wind_ashareleadunderwriter.netcollection is '募资净额合计(万元)';
comment on column ${iol_schema}.wind_ashareleadunderwriter.avg_totalcoll is '募集总额算术平均 (万元)';
comment on column ${iol_schema}.wind_ashareleadunderwriter.avg_netcoll is '募资净额算术平均 (万元)';
comment on column ${iol_schema}.wind_ashareleadunderwriter.opdate is '';
comment on column ${iol_schema}.wind_ashareleadunderwriter.opmode is '';
comment on column ${iol_schema}.wind_ashareleadunderwriter.start_dt is '开始时间';
comment on column ${iol_schema}.wind_ashareleadunderwriter.end_dt is '结束时间';
comment on column ${iol_schema}.wind_ashareleadunderwriter.id_mark is '增删标志';
comment on column ${iol_schema}.wind_ashareleadunderwriter.etl_timestamp is 'ETL处理时间戳';
