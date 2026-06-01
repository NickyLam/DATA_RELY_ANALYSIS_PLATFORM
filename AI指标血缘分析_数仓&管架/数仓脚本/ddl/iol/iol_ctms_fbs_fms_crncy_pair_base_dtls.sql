/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_fms_crncy_pair_base_dtls
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls(
    cpb_crncy_pair_srno number(8,0) -- 第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。
    ,cpb_frst_crncy_code varchar2(5) -- 被报价货币
    ,cpb_scnd_crncy_code varchar2(5) -- 报价货币
    ,cpb_crncy_pair_shrt_desc varchar2(60) -- 货币对英文简称
    ,cpb_crncy_pair_prcsn_count number -- 注意，货币1的单位均为1元
    ,cpb_frwrd_spread_count number -- 远（掉）期点报价精度
    ,cpb_frwrd_prcsn_count number(4,0) -- 远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元
    ,cpb_entry_unit_amnt number -- 为10的n次方 输入价格 / 报价输入系数 才是实际保存的价格
    ,cpb_show_unit_amnt number -- 为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2
    ,cpb_show_big_count number -- 
    ,cpb_show_big_offst_count number -- 从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1
    ,cpb_crncy_pair_roun_off_indc number -- 4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值
    ,cpb_cp_stlmnt_speed_indc number(2,0) -- 0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）
    ,cpb_mkt_indc number(2,0) -- 0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)
    ,cpb_crncy_pair_stts_indc number(2,0) -- 0：正常使用 1：已经删除或无效 2：过期
    ,cpb_crtd_user_id number(5,0) -- 记录创建用户
    ,cpb_crtd_date date -- 记录创建日期
    ,cpb_updtd_user_id number(5,0) -- 记录修改用户
    ,cpb_updtd_date date -- 记录修改日期
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
grant select on ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls is '货币对视图';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_crncy_pair_srno is '第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_frst_crncy_code is '被报价货币';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_scnd_crncy_code is '报价货币';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_crncy_pair_shrt_desc is '货币对英文简称';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_crncy_pair_prcsn_count is '注意，货币1的单位均为1元';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_frwrd_spread_count is '远（掉）期点报价精度';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_frwrd_prcsn_count is '远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_entry_unit_amnt is '为10的n次方 输入价格 / 报价输入系数 才是实际保存的价格';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_show_unit_amnt is '为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_show_big_count is '';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_show_big_offst_count is '从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_crncy_pair_roun_off_indc is '4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_cp_stlmnt_speed_indc is '0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_mkt_indc is '0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_crncy_pair_stts_indc is '0：正常使用 1：已经删除或无效 2：过期';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_crtd_user_id is '记录创建用户';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_crtd_date is '记录创建日期';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_updtd_user_id is '记录修改用户';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.cpb_updtd_date is '记录修改日期';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls.etl_timestamp is 'ETL处理时间戳';
