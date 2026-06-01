/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharecapitalization
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharecapitalization
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharecapitalization purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharecapitalization(
    object_id varchar2(150) -- 对象id
    ,wind_code varchar2(60) -- wind代码
    ,s_info_windcode varchar2(60) -- wind代码
    ,change_dt varchar2(12) -- 变动日期
    ,tot_shr number(24,8) -- 总股本(万股)
    ,float_shr number(24,8) -- 流通股(万股)
    ,float_a_shr number(24,8) -- 流通a股(万股)
    ,float_b_shr number(24,8) -- 流通b股(万股)
    ,float_h_shr number(24,8) -- 流通h股(万股)
    ,float_overseas_shr number(24,8) -- 境外流通股(万股)
    ,restricted_a_shr number(24,8) -- 限售a股(万股)
    ,s_share_rtd_state number(24,8) -- 限售股份(国家持股)(万股)
    ,s_share_rtd_statejur number(24,8) -- 限售股份(国有法人持股)(万股)
    ,s_share_rtd_subotherdomes number(24,8) -- 限售股份(其他内资持股)(万股)
    ,s_share_rtd_domesjur number(24,8) -- 限售股份(境内法人持股)(万股)
    ,s_share_rtd_inst number(24,8) -- 限售股份(机构配售股份)(万股)
    ,s_share_rtd_domesnp number(24,8) -- 限售股份(境内自然人持股)(万股)
    ,s_share_rtd_senmanager number(24,8) -- 限售股份(高管持股)(万股)
    ,s_share_rtd_subfrgn number(24,8) -- 限售股份(外资持股)(万股)
    ,s_share_rtd_frgnjur number(24,8) -- 限售股份(境外法人持股)(万股)
    ,s_share_rtd_frgnnp number(24,8) -- 限售股份(境外自然人持股)(万股)
    ,restricted_b_shr number(24,8) -- 限售b股
    ,other_restricted_shr number(24,8) -- 其他限售股
    ,non_tradable_shr number(24,8) -- 非流通股
    ,s_share_ntrd_state_pct number(24,8) -- 国有股(万股)
    ,s_share_ntrd_state number(24,8) -- 国家股(万股)
    ,s_share_ntrd_statjur number(24,8) -- 国有法人股(万股)
    ,s_share_ntrd_subdomesjur number(24,8) -- 境内法人股(万股)
    ,s_share_ntrd_domesinitor number(24,8) -- 境内发起人股(万股)
    ,s_share_ntrd_ipojuris number(24,8) -- 募集法人股(万股)
    ,s_share_ntrd_genjuris number(24,8) -- 一般法人股(万股)
    ,s_share_ntrd_strtinvestor number(24,8) -- 战略投资者持股(万股)
    ,s_share_ntrd_fundbal number(24,8) -- 基金持股(万股)
    ,s_share_ntrd_ipoinip number(24,8) -- 自然人股(万股)
    ,s_share_ntrd_trfnshare number(24,8) -- 转配股(万股)
    ,s_share_ntrd_snormnger number(24,8) -- 高管股(万股)
    ,s_share_ntrd_insderemp number(24,8) -- 内部职工股(万股)
    ,s_share_ntrd_prfshare number(24,8) -- 优先股(万股)
    ,s_share_ntrd_nonlstfrgn number(24,8) -- 非上市外资股(万股)
    ,s_share_ntrd_staq number(24,8) -- staq股(万股)
    ,s_share_ntrd_net number(24,8) -- net股(万股)
    ,s_share_changereason varchar2(45) -- 股本变动原因
    ,ann_dt varchar2(12) -- 公告日期
    ,change_dt1 varchar2(12) -- 变动日期1
    ,cur_sign number(1,0) -- 最新标志
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
grant select on ${iol_schema}.wind_asharecapitalization to ${iml_schema};
grant select on ${iol_schema}.wind_asharecapitalization to ${icl_schema};
grant select on ${iol_schema}.wind_asharecapitalization to ${idl_schema};
grant select on ${iol_schema}.wind_asharecapitalization to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharecapitalization is '中国A股股本';
comment on column ${iol_schema}.wind_asharecapitalization.object_id is '对象id';
comment on column ${iol_schema}.wind_asharecapitalization.wind_code is 'wind代码';
comment on column ${iol_schema}.wind_asharecapitalization.s_info_windcode is 'wind代码';
comment on column ${iol_schema}.wind_asharecapitalization.change_dt is '变动日期';
comment on column ${iol_schema}.wind_asharecapitalization.tot_shr is '总股本(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.float_shr is '流通股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.float_a_shr is '流通a股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.float_b_shr is '流通b股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.float_h_shr is '流通h股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.float_overseas_shr is '境外流通股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.restricted_a_shr is '限售a股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_state is '限售股份(国家持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_statejur is '限售股份(国有法人持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_subotherdomes is '限售股份(其他内资持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_domesjur is '限售股份(境内法人持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_inst is '限售股份(机构配售股份)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_domesnp is '限售股份(境内自然人持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_senmanager is '限售股份(高管持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_subfrgn is '限售股份(外资持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_frgnjur is '限售股份(境外法人持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_rtd_frgnnp is '限售股份(境外自然人持股)(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.restricted_b_shr is '限售b股';
comment on column ${iol_schema}.wind_asharecapitalization.other_restricted_shr is '其他限售股';
comment on column ${iol_schema}.wind_asharecapitalization.non_tradable_shr is '非流通股';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_state_pct is '国有股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_state is '国家股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_statjur is '国有法人股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_subdomesjur is '境内法人股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_domesinitor is '境内发起人股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_ipojuris is '募集法人股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_genjuris is '一般法人股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_strtinvestor is '战略投资者持股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_fundbal is '基金持股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_ipoinip is '自然人股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_trfnshare is '转配股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_snormnger is '高管股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_insderemp is '内部职工股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_prfshare is '优先股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_nonlstfrgn is '非上市外资股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_staq is 'staq股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_ntrd_net is 'net股(万股)';
comment on column ${iol_schema}.wind_asharecapitalization.s_share_changereason is '股本变动原因';
comment on column ${iol_schema}.wind_asharecapitalization.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_asharecapitalization.change_dt1 is '变动日期1';
comment on column ${iol_schema}.wind_asharecapitalization.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_asharecapitalization.opdate is '';
comment on column ${iol_schema}.wind_asharecapitalization.opmode is '';
comment on column ${iol_schema}.wind_asharecapitalization.start_dt is '开始时间';
comment on column ${iol_schema}.wind_asharecapitalization.end_dt is '结束时间';
comment on column ${iol_schema}.wind_asharecapitalization.id_mark is '增删标志';
comment on column ${iol_schema}.wind_asharecapitalization.etl_timestamp is 'ETL处理时间戳';
