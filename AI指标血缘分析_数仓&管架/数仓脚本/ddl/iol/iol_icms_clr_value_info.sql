/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_value_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_value_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_value_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_value_info(
    clrid varchar2(32) -- 押品编号
    ,evalmode varchar2(2) -- 评估方式 01-外部评估、02-内部评估、03-外部和内部评估
    ,evaldate date -- 估值日期
    ,curreny varchar2(10) -- 币种
    ,rate number(18,10) -- 汇率
    ,outevalstartdate date -- 外部评估价值有效期起始日
    ,outevalexpdate date -- 外部评估价值有效期截止日
    ,outevaldeptcode varchar2(300) -- 外部评估机构
    ,outevalmethod varchar2(100) -- 评估方法
    ,outevalflag varchar2(3) -- 是否有外部预评估报告
    ,outevalamt1 number(20,2) -- 外部预评估报告的评估价值
    ,outevaldate date -- 外部评估基准日
    ,outevalamt number(20,2) -- 外部正式评估报告的评估价值
    ,evalamt number(20,2) -- 内部评估价值
    ,evalamt2 number(20,2) -- 申请评估确认价值
    ,businessinsid varchar2(32) -- 流程编号（入库初评-出入库任务流水号、价值重估为-押品变更任务流水号、自动重估该字段为空）
    ,confmamt number(20,2) -- 我行确认价值
    ,condate date -- 评估认定日期
    ,firstoutevalamt number(20,2) -- 初评外部正式评估价值
    ,firstevalamt number(20,2) -- 初评内部评估价值
    ,firstconfmamt number(20,2) -- 初评我行确认价值
    ,startbusinessinsid varchar2(30) -- 初评流程编号
    ,status varchar2(3) -- 流程状态 1 流程中 0正常
    ,autooutevalamt number(20,2) -- 世联评估价值
    ,autooutevalamt2 number(20,2) -- 房讯通评估价值
    ,outevaldeptcode2 varchar2(300) -- 外部评估机构2
    ,outevalamt2 number(20,2) -- 外部正式评估报告的评估价值2
    ,outevaldate2 date -- 外部评估基准日2
    ,outevalflag2 varchar2(3) -- 是否有外部评估报告2
    ,outevalstartdate2 date -- 外部评估价值有效期起始日2
    ,outevalexpdate2 date -- 外部评估价值有效期截止日2
    ,confmdeptcode varchar2(300) -- 最终选定外部评估机构
    ,calculateflag varchar2(3) -- 测算标识
    ,accoutingamt number(20,2) -- 记账价值
    ,accoutingorgid varchar2(30) -- 记账机构
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,slcaseid varchar2(64) -- 世联估值案例编号
    ,fxtcaseid varchar2(64) -- 房讯通估值案例编号
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
grant select on ${iol_schema}.icms_clr_value_info to ${iml_schema};
grant select on ${iol_schema}.icms_clr_value_info to ${icl_schema};
grant select on ${iol_schema}.icms_clr_value_info to ${idl_schema};
grant select on ${iol_schema}.icms_clr_value_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_value_info is '押品价值信息表';
comment on column ${iol_schema}.icms_clr_value_info.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_value_info.evalmode is '评估方式 01-外部评估、02-内部评估、03-外部和内部评估';
comment on column ${iol_schema}.icms_clr_value_info.evaldate is '估值日期';
comment on column ${iol_schema}.icms_clr_value_info.curreny is '币种';
comment on column ${iol_schema}.icms_clr_value_info.rate is '汇率';
comment on column ${iol_schema}.icms_clr_value_info.outevalstartdate is '外部评估价值有效期起始日';
comment on column ${iol_schema}.icms_clr_value_info.outevalexpdate is '外部评估价值有效期截止日';
comment on column ${iol_schema}.icms_clr_value_info.outevaldeptcode is '外部评估机构';
comment on column ${iol_schema}.icms_clr_value_info.outevalmethod is '评估方法';
comment on column ${iol_schema}.icms_clr_value_info.outevalflag is '是否有外部预评估报告';
comment on column ${iol_schema}.icms_clr_value_info.outevalamt1 is '外部预评估报告的评估价值';
comment on column ${iol_schema}.icms_clr_value_info.outevaldate is '外部评估基准日';
comment on column ${iol_schema}.icms_clr_value_info.outevalamt is '外部正式评估报告的评估价值';
comment on column ${iol_schema}.icms_clr_value_info.evalamt is '内部评估价值';
comment on column ${iol_schema}.icms_clr_value_info.evalamt2 is '申请评估确认价值';
comment on column ${iol_schema}.icms_clr_value_info.businessinsid is '流程编号（入库初评-出入库任务流水号、价值重估为-押品变更任务流水号、自动重估该字段为空）';
comment on column ${iol_schema}.icms_clr_value_info.confmamt is '我行确认价值';
comment on column ${iol_schema}.icms_clr_value_info.condate is '评估认定日期';
comment on column ${iol_schema}.icms_clr_value_info.firstoutevalamt is '初评外部正式评估价值';
comment on column ${iol_schema}.icms_clr_value_info.firstevalamt is '初评内部评估价值';
comment on column ${iol_schema}.icms_clr_value_info.firstconfmamt is '初评我行确认价值';
comment on column ${iol_schema}.icms_clr_value_info.startbusinessinsid is '初评流程编号';
comment on column ${iol_schema}.icms_clr_value_info.status is '流程状态 1 流程中 0正常';
comment on column ${iol_schema}.icms_clr_value_info.autooutevalamt is '世联评估价值';
comment on column ${iol_schema}.icms_clr_value_info.autooutevalamt2 is '房讯通评估价值';
comment on column ${iol_schema}.icms_clr_value_info.outevaldeptcode2 is '外部评估机构2';
comment on column ${iol_schema}.icms_clr_value_info.outevalamt2 is '外部正式评估报告的评估价值2';
comment on column ${iol_schema}.icms_clr_value_info.outevaldate2 is '外部评估基准日2';
comment on column ${iol_schema}.icms_clr_value_info.outevalflag2 is '是否有外部评估报告2';
comment on column ${iol_schema}.icms_clr_value_info.outevalstartdate2 is '外部评估价值有效期起始日2';
comment on column ${iol_schema}.icms_clr_value_info.outevalexpdate2 is '外部评估价值有效期截止日2';
comment on column ${iol_schema}.icms_clr_value_info.confmdeptcode is '最终选定外部评估机构';
comment on column ${iol_schema}.icms_clr_value_info.calculateflag is '测算标识';
comment on column ${iol_schema}.icms_clr_value_info.accoutingamt is '记账价值';
comment on column ${iol_schema}.icms_clr_value_info.accoutingorgid is '记账机构';
comment on column ${iol_schema}.icms_clr_value_info.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_value_info.slcaseid is '世联估值案例编号';
comment on column ${iol_schema}.icms_clr_value_info.fxtcaseid is '房讯通估值案例编号';
comment on column ${iol_schema}.icms_clr_value_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_value_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_value_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_value_info.etl_timestamp is 'ETL处理时间戳';
