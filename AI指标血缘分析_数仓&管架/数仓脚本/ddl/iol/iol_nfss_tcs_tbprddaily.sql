/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbprddaily
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbprddaily
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbprddaily purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbprddaily(
    iss_date number(22,0) -- 发布日期
    ,cfm_date number(22,0) -- 确认日期(当天日期)
    ,prd_code varchar2(30) -- 产品代码
    ,ta_code varchar2(14) -- ta代码
    ,prd_scale number(18,2) -- 产品总规模
    ,tot_vol number(18,3) -- 产品总份数
    ,increase_vol number(18,3) -- 当日增加份数
    ,reduce_vol number(18,3) -- 当日减少份数
    ,nav number(18,8) -- 单位净值
    ,face_value number(18,8) -- 产品面值
    ,larg_red_flag varchar2(2) -- 巨额赎回标志
    ,larg_red_cfm_rate number(9,8) -- 巨额赎回确认比例
    ,chgout_cfm_rate number(9,8) -- 巨额赎回转出确认比例
    ,excess_flag varchar2(2) -- 超额申购标志
    ,excess_cfm_rate number(9,8) -- 超额申购确认比例
    ,income_rate number(18,8) -- 年化收益率
    ,income number(18,8) -- 产品收益
    ,income_unit number(24,8) -- 万份单位收益
    ,unassign_income number(18,3) -- 未分配收益
    ,assign_income number(18,2) -- 当天分配收益
    ,assign_flag varchar2(2) -- 收益分配标志
    ,conv_flag varchar2(2) -- 转换标志
    ,status varchar2(2) -- 产品状态
    ,last_status varchar2(2) -- 上日产品状态
    ,tot_nav number(23,8) -- 产品累计净值
    ,amt1 number(18,2) -- 备用金额1
    ,reserve1 varchar2(375) -- 备用1
    ,reserve2 varchar2(375) -- 备用2
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
grant select on ${iol_schema}.nfss_tcs_tbprddaily to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbprddaily to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbprddaily to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbprddaily to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbprddaily is '信托产品日信息表';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.iss_date is '发布日期';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.cfm_date is '确认日期(当天日期)';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.prd_scale is '产品总规模';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.tot_vol is '产品总份数';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.increase_vol is '当日增加份数';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.reduce_vol is '当日减少份数';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.nav is '单位净值';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.face_value is '产品面值';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.larg_red_flag is '巨额赎回标志';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.larg_red_cfm_rate is '巨额赎回确认比例';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.chgout_cfm_rate is '巨额赎回转出确认比例';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.excess_flag is '超额申购标志';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.excess_cfm_rate is '超额申购确认比例';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.income_rate is '年化收益率';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.income is '产品收益';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.income_unit is '万份单位收益';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.unassign_income is '未分配收益';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.assign_income is '当天分配收益';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.assign_flag is '收益分配标志';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.conv_flag is '转换标志';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.status is '产品状态';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.last_status is '上日产品状态';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.tot_nav is '产品累计净值';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.reserve1 is '备用1';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.reserve2 is '备用2';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbprddaily.etl_timestamp is 'ETL处理时间戳';
