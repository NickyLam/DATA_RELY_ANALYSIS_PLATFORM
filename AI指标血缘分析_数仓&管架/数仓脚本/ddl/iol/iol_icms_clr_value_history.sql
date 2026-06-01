/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_value_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_value_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_value_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_value_history(
    serialno varchar2(32) -- 价值记录流水号
    ,clrid varchar2(32) -- 押品编号
    ,evalmode varchar2(6) -- 评估方式（01-外部评估、02-内部评估、03-内外部综合评估）
    ,evaldate date -- 估值日期
    ,curreny varchar2(10) -- 币种
    ,rate number(18,10) -- 汇率
    ,outevalexpdate date -- 外部评估价值估值到期日期
    ,outevaldeptcode varchar2(300) -- 外部评估机构
    ,outevalmethod varchar2(100) -- 外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）
    ,outevalflag varchar2(3) -- 是否有外部预评估报告（0-否、1-是）
    ,outevalamt1 number(20,2) -- 外部预评估报告的评估价值
    ,outevaldate date -- 外部正式评估报告评估日期
    ,outevalamt number(20,2) -- 外部正式评估报告的评估价值
    ,evalamt number(20,2) -- 内部评估价值
    ,evalamt2 number(20,2) -- 申请评估确认价值
    ,businessinsid varchar2(30) -- 流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）
    ,confmamt number(20,2) -- 我行确认价值
    ,condate date -- 评估认定日期
    ,firstoutevalamt number(20,2) -- 初评外部正式评估价值
    ,firstevalamt number(20,2) -- 初评内部评估价值
    ,firstconfmamt number(20,2) -- 初评我行确认价值
    ,startbusinessinsid varchar2(30) -- 初评流程编号
    ,verecoginition varchar2(6) -- 押品价值认定方式
    ,outevalstatus varchar2(6) -- 准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）
    ,outevalextcustcname varchar2(120) -- 外部评估机构名称
    ,slflag varchar2(3) -- 是否世联评估
    ,isaccurateprice varchar2(3) -- 是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
    ,outevalstartdate date -- 外部评估价值有效期起始日
    ,isvaluechange varchar2(2) -- 是否变更我行确认价值
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
grant select on ${iol_schema}.icms_clr_value_history to ${iml_schema};
grant select on ${iol_schema}.icms_clr_value_history to ${icl_schema};
grant select on ${iol_schema}.icms_clr_value_history to ${idl_schema};
grant select on ${iol_schema}.icms_clr_value_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_value_history is '押品价值历史信息表';
comment on column ${iol_schema}.icms_clr_value_history.serialno is '价值记录流水号';
comment on column ${iol_schema}.icms_clr_value_history.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_value_history.evalmode is '评估方式（01-外部评估、02-内部评估、03-内外部综合评估）';
comment on column ${iol_schema}.icms_clr_value_history.evaldate is '估值日期';
comment on column ${iol_schema}.icms_clr_value_history.curreny is '币种';
comment on column ${iol_schema}.icms_clr_value_history.rate is '汇率';
comment on column ${iol_schema}.icms_clr_value_history.outevalexpdate is '外部评估价值估值到期日期';
comment on column ${iol_schema}.icms_clr_value_history.outevaldeptcode is '外部评估机构';
comment on column ${iol_schema}.icms_clr_value_history.outevalmethod is '外部评估方法（01-指数法_外部指数、02-指数法_内部构建指数、03-市场法、04-收益法、05-重置成本法、06-工程进度法、07-非上市公司股权净资产比例法、08-直接引用法_金融质抵质押品、09-直接引用法_动产、10-直接引用法_房地产、11-直接引用法_询价、12-其他）';
comment on column ${iol_schema}.icms_clr_value_history.outevalflag is '是否有外部预评估报告（0-否、1-是）';
comment on column ${iol_schema}.icms_clr_value_history.outevalamt1 is '外部预评估报告的评估价值';
comment on column ${iol_schema}.icms_clr_value_history.outevaldate is '外部正式评估报告评估日期';
comment on column ${iol_schema}.icms_clr_value_history.outevalamt is '外部正式评估报告的评估价值';
comment on column ${iol_schema}.icms_clr_value_history.evalamt is '内部评估价值';
comment on column ${iol_schema}.icms_clr_value_history.evalamt2 is '申请评估确认价值';
comment on column ${iol_schema}.icms_clr_value_history.businessinsid is '流程编号（我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空）';
comment on column ${iol_schema}.icms_clr_value_history.confmamt is '我行确认价值';
comment on column ${iol_schema}.icms_clr_value_history.condate is '评估认定日期';
comment on column ${iol_schema}.icms_clr_value_history.firstoutevalamt is '初评外部正式评估价值';
comment on column ${iol_schema}.icms_clr_value_history.firstevalamt is '初评内部评估价值';
comment on column ${iol_schema}.icms_clr_value_history.firstconfmamt is '初评我行确认价值';
comment on column ${iol_schema}.icms_clr_value_history.startbusinessinsid is '初评流程编号';
comment on column ${iol_schema}.icms_clr_value_history.verecoginition is '押品价值认定方式';
comment on column ${iol_schema}.icms_clr_value_history.outevalstatus is '准入状态（01-未准入、02-已准入、03-黑名单、04-已退出、05-已取消）';
comment on column ${iol_schema}.icms_clr_value_history.outevalextcustcname is '外部评估机构名称';
comment on column ${iol_schema}.icms_clr_value_history.slflag is '是否世联评估';
comment on column ${iol_schema}.icms_clr_value_history.isaccurateprice is '是否精准价(1是【按照楼盘id+楼栋id+房号编码+面积，世联返回的价格】 0否【世联返回均价】';
comment on column ${iol_schema}.icms_clr_value_history.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_value_history.autooutevalamt is '世联评估价值';
comment on column ${iol_schema}.icms_clr_value_history.autooutevalamt2 is '房讯通评估价值';
comment on column ${iol_schema}.icms_clr_value_history.outevaldeptcode2 is '外部评估机构2';
comment on column ${iol_schema}.icms_clr_value_history.outevalamt2 is '外部正式评估报告的评估价值2';
comment on column ${iol_schema}.icms_clr_value_history.outevaldate2 is '外部评估基准日2';
comment on column ${iol_schema}.icms_clr_value_history.outevalflag2 is '是否有外部评估报告2';
comment on column ${iol_schema}.icms_clr_value_history.outevalstartdate2 is '外部评估价值有效期起始日2';
comment on column ${iol_schema}.icms_clr_value_history.outevalexpdate2 is '外部评估价值有效期截止日2';
comment on column ${iol_schema}.icms_clr_value_history.confmdeptcode is '最终选定外部评估机构';
comment on column ${iol_schema}.icms_clr_value_history.calculateflag is '测算标识';
comment on column ${iol_schema}.icms_clr_value_history.accoutingamt is '记账价值';
comment on column ${iol_schema}.icms_clr_value_history.accoutingorgid is '记账机构';
comment on column ${iol_schema}.icms_clr_value_history.outevalstartdate is '外部评估价值有效期起始日';
comment on column ${iol_schema}.icms_clr_value_history.isvaluechange is '是否变更我行确认价值';
comment on column ${iol_schema}.icms_clr_value_history.slcaseid is '世联估值案例编号';
comment on column ${iol_schema}.icms_clr_value_history.fxtcaseid is '房讯通估值案例编号';
comment on column ${iol_schema}.icms_clr_value_history.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_value_history.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_value_history.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_value_history.etl_timestamp is 'ETL处理时间戳';
