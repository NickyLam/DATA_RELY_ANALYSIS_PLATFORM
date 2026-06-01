/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_fms_crncy_pair_base_dtls
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_op purge;
drop table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls where 0=1;

create table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_cl(
            cpb_crncy_pair_srno -- 第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。
            ,cpb_frst_crncy_code -- 被报价货币
            ,cpb_scnd_crncy_code -- 报价货币
            ,cpb_crncy_pair_shrt_desc -- 货币对英文简称
            ,cpb_crncy_pair_prcsn_count -- 注意，货币1的单位均为1元
            ,cpb_frwrd_spread_count -- 远（掉）期点报价精度
            ,cpb_frwrd_prcsn_count -- 远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元
            ,cpb_entry_unit_amnt -- 为10的n次方输入价格 / 报价输入系数 才是实际保存的价格
            ,cpb_show_unit_amnt -- 为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2
            ,cpb_show_big_count -- 
            ,cpb_show_big_offst_count -- 从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1
            ,cpb_crncy_pair_roun_off_indc -- 4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值
            ,cpb_cp_stlmnt_speed_indc -- 0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）
            ,cpb_mkt_indc -- 0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)
            ,cpb_crncy_pair_stts_indc -- 0：正常使用 1：已经删除或无效 2：过期
            ,cpb_crtd_user_id -- 记录创建用户
            ,cpb_crtd_date -- 记录创建日期
            ,cpb_updtd_user_id -- 记录修改用户
            ,cpb_updtd_date -- 记录修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_op(
            cpb_crncy_pair_srno -- 第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。
            ,cpb_frst_crncy_code -- 被报价货币
            ,cpb_scnd_crncy_code -- 报价货币
            ,cpb_crncy_pair_shrt_desc -- 货币对英文简称
            ,cpb_crncy_pair_prcsn_count -- 注意，货币1的单位均为1元
            ,cpb_frwrd_spread_count -- 远（掉）期点报价精度
            ,cpb_frwrd_prcsn_count -- 远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元
            ,cpb_entry_unit_amnt -- 为10的n次方输入价格 / 报价输入系数 才是实际保存的价格
            ,cpb_show_unit_amnt -- 为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2
            ,cpb_show_big_count -- 
            ,cpb_show_big_offst_count -- 从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1
            ,cpb_crncy_pair_roun_off_indc -- 4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值
            ,cpb_cp_stlmnt_speed_indc -- 0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）
            ,cpb_mkt_indc -- 0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)
            ,cpb_crncy_pair_stts_indc -- 0：正常使用 1：已经删除或无效 2：过期
            ,cpb_crtd_user_id -- 记录创建用户
            ,cpb_crtd_date -- 记录创建日期
            ,cpb_updtd_user_id -- 记录修改用户
            ,cpb_updtd_date -- 记录修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cpb_crncy_pair_srno, o.cpb_crncy_pair_srno) as cpb_crncy_pair_srno -- 第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。
    ,nvl(n.cpb_frst_crncy_code, o.cpb_frst_crncy_code) as cpb_frst_crncy_code -- 被报价货币
    ,nvl(n.cpb_scnd_crncy_code, o.cpb_scnd_crncy_code) as cpb_scnd_crncy_code -- 报价货币
    ,nvl(n.cpb_crncy_pair_shrt_desc, o.cpb_crncy_pair_shrt_desc) as cpb_crncy_pair_shrt_desc -- 货币对英文简称
    ,nvl(n.cpb_crncy_pair_prcsn_count, o.cpb_crncy_pair_prcsn_count) as cpb_crncy_pair_prcsn_count -- 注意，货币1的单位均为1元
    ,nvl(n.cpb_frwrd_spread_count, o.cpb_frwrd_spread_count) as cpb_frwrd_spread_count -- 远（掉）期点报价精度
    ,nvl(n.cpb_frwrd_prcsn_count, o.cpb_frwrd_prcsn_count) as cpb_frwrd_prcsn_count -- 远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元
    ,nvl(n.cpb_entry_unit_amnt, o.cpb_entry_unit_amnt) as cpb_entry_unit_amnt -- 为10的n次方输入价格 / 报价输入系数 才是实际保存的价格
    ,nvl(n.cpb_show_unit_amnt, o.cpb_show_unit_amnt) as cpb_show_unit_amnt -- 为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2
    ,nvl(n.cpb_show_big_count, o.cpb_show_big_count) as cpb_show_big_count -- 
    ,nvl(n.cpb_show_big_offst_count, o.cpb_show_big_offst_count) as cpb_show_big_offst_count -- 从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1
    ,nvl(n.cpb_crncy_pair_roun_off_indc, o.cpb_crncy_pair_roun_off_indc) as cpb_crncy_pair_roun_off_indc -- 4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值
    ,nvl(n.cpb_cp_stlmnt_speed_indc, o.cpb_cp_stlmnt_speed_indc) as cpb_cp_stlmnt_speed_indc -- 0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）
    ,nvl(n.cpb_mkt_indc, o.cpb_mkt_indc) as cpb_mkt_indc -- 0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)
    ,nvl(n.cpb_crncy_pair_stts_indc, o.cpb_crncy_pair_stts_indc) as cpb_crncy_pair_stts_indc -- 0：正常使用 1：已经删除或无效 2：过期
    ,nvl(n.cpb_crtd_user_id, o.cpb_crtd_user_id) as cpb_crtd_user_id -- 记录创建用户
    ,nvl(n.cpb_crtd_date, o.cpb_crtd_date) as cpb_crtd_date -- 记录创建日期
    ,nvl(n.cpb_updtd_user_id, o.cpb_updtd_user_id) as cpb_updtd_user_id -- 记录修改用户
    ,nvl(n.cpb_updtd_date, o.cpb_updtd_date) as cpb_updtd_date -- 记录修改日期
    ,case when
            n.cpb_crncy_pair_srno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cpb_crncy_pair_srno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cpb_crncy_pair_srno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_fms_crncy_pair_base_dtls where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cpb_crncy_pair_srno = n.cpb_crncy_pair_srno
where (
        o.cpb_crncy_pair_srno is null
    )
    or (
        n.cpb_crncy_pair_srno is null
    )
    or (
        o.cpb_frst_crncy_code <> n.cpb_frst_crncy_code
        or o.cpb_scnd_crncy_code <> n.cpb_scnd_crncy_code
        or o.cpb_crncy_pair_shrt_desc <> n.cpb_crncy_pair_shrt_desc
        or o.cpb_crncy_pair_prcsn_count <> n.cpb_crncy_pair_prcsn_count
        or o.cpb_frwrd_spread_count <> n.cpb_frwrd_spread_count
        or o.cpb_frwrd_prcsn_count <> n.cpb_frwrd_prcsn_count
        or o.cpb_entry_unit_amnt <> n.cpb_entry_unit_amnt
        or o.cpb_show_unit_amnt <> n.cpb_show_unit_amnt
        or o.cpb_show_big_count <> n.cpb_show_big_count
        or o.cpb_show_big_offst_count <> n.cpb_show_big_offst_count
        or o.cpb_crncy_pair_roun_off_indc <> n.cpb_crncy_pair_roun_off_indc
        or o.cpb_cp_stlmnt_speed_indc <> n.cpb_cp_stlmnt_speed_indc
        or o.cpb_mkt_indc <> n.cpb_mkt_indc
        or o.cpb_crncy_pair_stts_indc <> n.cpb_crncy_pair_stts_indc
        or o.cpb_crtd_user_id <> n.cpb_crtd_user_id
        or o.cpb_crtd_date <> n.cpb_crtd_date
        or o.cpb_updtd_user_id <> n.cpb_updtd_user_id
        or o.cpb_updtd_date <> n.cpb_updtd_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_cl(
            cpb_crncy_pair_srno -- 第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。
            ,cpb_frst_crncy_code -- 被报价货币
            ,cpb_scnd_crncy_code -- 报价货币
            ,cpb_crncy_pair_shrt_desc -- 货币对英文简称
            ,cpb_crncy_pair_prcsn_count -- 注意，货币1的单位均为1元
            ,cpb_frwrd_spread_count -- 远（掉）期点报价精度
            ,cpb_frwrd_prcsn_count -- 远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元
            ,cpb_entry_unit_amnt -- 为10的n次方输入价格 / 报价输入系数 才是实际保存的价格
            ,cpb_show_unit_amnt -- 为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2
            ,cpb_show_big_count -- 
            ,cpb_show_big_offst_count -- 从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1
            ,cpb_crncy_pair_roun_off_indc -- 4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值
            ,cpb_cp_stlmnt_speed_indc -- 0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）
            ,cpb_mkt_indc -- 0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)
            ,cpb_crncy_pair_stts_indc -- 0：正常使用 1：已经删除或无效 2：过期
            ,cpb_crtd_user_id -- 记录创建用户
            ,cpb_crtd_date -- 记录创建日期
            ,cpb_updtd_user_id -- 记录修改用户
            ,cpb_updtd_date -- 记录修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_op(
            cpb_crncy_pair_srno -- 第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。
            ,cpb_frst_crncy_code -- 被报价货币
            ,cpb_scnd_crncy_code -- 报价货币
            ,cpb_crncy_pair_shrt_desc -- 货币对英文简称
            ,cpb_crncy_pair_prcsn_count -- 注意，货币1的单位均为1元
            ,cpb_frwrd_spread_count -- 远（掉）期点报价精度
            ,cpb_frwrd_prcsn_count -- 远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元
            ,cpb_entry_unit_amnt -- 为10的n次方输入价格 / 报价输入系数 才是实际保存的价格
            ,cpb_show_unit_amnt -- 为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2
            ,cpb_show_big_count -- 
            ,cpb_show_big_offst_count -- 从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1
            ,cpb_crncy_pair_roun_off_indc -- 4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值
            ,cpb_cp_stlmnt_speed_indc -- 0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）
            ,cpb_mkt_indc -- 0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)
            ,cpb_crncy_pair_stts_indc -- 0：正常使用 1：已经删除或无效 2：过期
            ,cpb_crtd_user_id -- 记录创建用户
            ,cpb_crtd_date -- 记录创建日期
            ,cpb_updtd_user_id -- 记录修改用户
            ,cpb_updtd_date -- 记录修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cpb_crncy_pair_srno -- 第一条货币对记录，即序列号为0的记录，货币1和货币2均应为“___”， 表示所有货币对，用于限额设置等。
    ,o.cpb_frst_crncy_code -- 被报价货币
    ,o.cpb_scnd_crncy_code -- 报价货币
    ,o.cpb_crncy_pair_shrt_desc -- 货币对英文简称
    ,o.cpb_crncy_pair_prcsn_count -- 注意，货币1的单位均为1元
    ,o.cpb_frwrd_spread_count -- 远（掉）期点报价精度
    ,o.cpb_frwrd_prcsn_count -- 远期价格 ＝ 即期价格 ＋ 10 ** (-远期全价报价精度) 注意，货币1的单位均为1元
    ,o.cpb_entry_unit_amnt -- 为10的n次方输入价格 / 报价输入系数 才是实际保存的价格
    ,o.cpb_show_unit_amnt -- 为10的n次方 报价 * 报价显示系数 才是实际显示结果，JPY/CNY时候配置为2
    ,o.cpb_show_big_count -- 
    ,o.cpb_show_big_offst_count -- 从倒数第几位小数开始显示大数，跟BigNum Offset对应， HKD/CNY时候配置成1
    ,o.cpb_crncy_pair_roun_off_indc -- 4：四舍五入  0：全入 1：全舍，与java RoundingMode保持一值
    ,o.cpb_cp_stlmnt_speed_indc -- 0：T0（T+0） 1：T1（T+1） 2：T2（T+2） 3：T3（T+3） 4：T4（T+4）
    ,o.cpb_mkt_indc -- 0：结售汇 1：外币对 2：黄金市场 3：离岸市场(2.0.0)
    ,o.cpb_crncy_pair_stts_indc -- 0：正常使用 1：已经删除或无效 2：过期
    ,o.cpb_crtd_user_id -- 记录创建用户
    ,o.cpb_crtd_date -- 记录创建日期
    ,o.cpb_updtd_user_id -- 记录修改用户
    ,o.cpb_updtd_date -- 记录修改日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_bk o
    left join ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_op n
        on
            o.cpb_crncy_pair_srno = n.cpb_crncy_pair_srno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_cl d
        on
            o.cpb_crncy_pair_srno = d.cpb_crncy_pair_srno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls exchange partition p_19000101 with table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_cl;
alter table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_op purge;
drop table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_fms_crncy_pair_base_dtls_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_fms_crncy_pair_base_dtls',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
