/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fft_bus_info_h_isbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_fft_bus_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fft_bus_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fft_bus_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_fft_bus_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_fft_bus_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_fft_bus_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fft_bus_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,ref_no -- 参考号
    ,lc_bus_id -- 信用证业务编号
    ,tran_sketch -- 交易简述
    ,pkg_buy_bk_comb -- 包买行组合
    ,present_id -- 交单编号
    ,present_ps_name -- 交单人名称
    ,rgst_dt -- 登记日期
    ,open_dt -- 开立日期
    ,open_exp_dt -- 开立到期日期
    ,close_flg -- 关闭标志
    ,close_dt -- 关闭日期
    ,value_dt -- 起息日期
    ,aldy_tran_sell_flg -- 已转卖标志
    ,org_id -- 机构编号
    ,parent_intnal_id -- 父级内部编号
    ,parent_ref_no -- 父级参考号
    ,parent_tran_abbr -- 父级交易简称
    ,parent_tran_name -- 父级交易名称
    ,inv_role_name -- INV角色名称
    ,modif_dt -- 修改日期
    ,modif_cnt -- 修改次数
    ,oper_teller_id -- 经办柜员编号
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fft_bus_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_fft_bus_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fft_bus_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_fft_bus_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fft_bus_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_fpd-1
insert into ${iml_schema}.agt_fft_bus_info_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,ref_no -- 参考号
    ,lc_bus_id -- 信用证业务编号
    ,tran_sketch -- 交易简述
    ,pkg_buy_bk_comb -- 包买行组合
    ,present_id -- 交单编号
    ,present_ps_name -- 交单人名称
    ,rgst_dt -- 登记日期
    ,open_dt -- 开立日期
    ,open_exp_dt -- 开立到期日期
    ,close_flg -- 关闭标志
    ,close_dt -- 关闭日期
    ,value_dt -- 起息日期
    ,aldy_tran_sell_flg -- 已转卖标志
    ,org_id -- 机构编号
    ,parent_intnal_id -- 父级内部编号
    ,parent_ref_no -- 父级参考号
    ,parent_tran_abbr -- 父级交易简称
    ,parent_tran_name -- 父级交易名称
    ,inv_role_name -- INV角色名称
    ,modif_dt -- 修改日期
    ,modif_cnt -- 修改次数
    ,oper_teller_id -- 经办柜员编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300054'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 内部编号
    ,P1.OWNREF -- 参考号
    ,P1.INVREF -- 信用证业务编号
    ,P1.NAM -- 交易简述
    ,P1.BMHLST -- 包买行组合
    ,P1.SELREF -- 交单编号
    ,P1.SELNAM -- 交单人名称
    ,P1.CREDAT -- 登记日期
    ,P1.OPNDAT -- 开立日期
    ,P1.EXPDAT -- 开立到期日期
    ,decode(trim(P1.SILFLG),'Y','1','N','0','','-',P1.SILFLG) -- 关闭标志
    ,P1.CLSDAT -- 关闭日期
    ,P1.VALDAT -- 起息日期
    ,decode(trim(P1.RDSFLG),'Y','1','N','0','','-',P1.RDSFLG) -- 已转卖标志
    ,nvl(P2.BRANCH,' ') -- 机构编号
    ,P1.PNTINR -- 父级内部编号
    ,P1.PNTREF -- 父级参考号
    ,P1.PNTTYP -- 父级交易简称
    ,P1.PNTNAM -- 父级交易名称
    ,P1.INVNAM -- INV角色名称
    ,P1.AMEDAT -- 修改日期
    ,P1.AMENBR -- 修改次数
    ,P1.OWNUSR -- 经办柜员编号
    ,nvl(P3.TENDET,' ') -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_fpd' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_fpd p1
    left join ${iol_schema}.isbs_bch p2 on p1.etyextkey = p2.inr
and p2.start_dt <= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fpt p3 on p1.inr = p3.inr
and p3.start_dt <= to_date('${batch_date}','yyyymmdd') 
and p3.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fft_bus_info_h_isbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_fft_bus_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,ref_no -- 参考号
    ,lc_bus_id -- 信用证业务编号
    ,tran_sketch -- 交易简述
    ,pkg_buy_bk_comb -- 包买行组合
    ,present_id -- 交单编号
    ,present_ps_name -- 交单人名称
    ,rgst_dt -- 登记日期
    ,open_dt -- 开立日期
    ,open_exp_dt -- 开立到期日期
    ,close_flg -- 关闭标志
    ,close_dt -- 关闭日期
    ,value_dt -- 起息日期
    ,aldy_tran_sell_flg -- 已转卖标志
    ,org_id -- 机构编号
    ,parent_intnal_id -- 父级内部编号
    ,parent_ref_no -- 父级参考号
    ,parent_tran_abbr -- 父级交易简称
    ,parent_tran_name -- 父级交易名称
    ,inv_role_name -- INV角色名称
    ,modif_dt -- 修改日期
    ,modif_cnt -- 修改次数
    ,oper_teller_id -- 经办柜员编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fft_bus_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,ref_no -- 参考号
    ,lc_bus_id -- 信用证业务编号
    ,tran_sketch -- 交易简述
    ,pkg_buy_bk_comb -- 包买行组合
    ,present_id -- 交单编号
    ,present_ps_name -- 交单人名称
    ,rgst_dt -- 登记日期
    ,open_dt -- 开立日期
    ,open_exp_dt -- 开立到期日期
    ,close_flg -- 关闭标志
    ,close_dt -- 关闭日期
    ,value_dt -- 起息日期
    ,aldy_tran_sell_flg -- 已转卖标志
    ,org_id -- 机构编号
    ,parent_intnal_id -- 父级内部编号
    ,parent_ref_no -- 父级参考号
    ,parent_tran_abbr -- 父级交易简称
    ,parent_tran_name -- 父级交易名称
    ,inv_role_name -- INV角色名称
    ,modif_dt -- 修改日期
    ,modif_cnt -- 修改次数
    ,oper_teller_id -- 经办柜员编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.intnal_id, o.intnal_id) as intnal_id -- 内部编号
    ,nvl(n.ref_no, o.ref_no) as ref_no -- 参考号
    ,nvl(n.lc_bus_id, o.lc_bus_id) as lc_bus_id -- 信用证业务编号
    ,nvl(n.tran_sketch, o.tran_sketch) as tran_sketch -- 交易简述
    ,nvl(n.pkg_buy_bk_comb, o.pkg_buy_bk_comb) as pkg_buy_bk_comb -- 包买行组合
    ,nvl(n.present_id, o.present_id) as present_id -- 交单编号
    ,nvl(n.present_ps_name, o.present_ps_name) as present_ps_name -- 交单人名称
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开立日期
    ,nvl(n.open_exp_dt, o.open_exp_dt) as open_exp_dt -- 开立到期日期
    ,nvl(n.close_flg, o.close_flg) as close_flg -- 关闭标志
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 关闭日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.aldy_tran_sell_flg, o.aldy_tran_sell_flg) as aldy_tran_sell_flg -- 已转卖标志
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.parent_intnal_id, o.parent_intnal_id) as parent_intnal_id -- 父级内部编号
    ,nvl(n.parent_ref_no, o.parent_ref_no) as parent_ref_no -- 父级参考号
    ,nvl(n.parent_tran_abbr, o.parent_tran_abbr) as parent_tran_abbr -- 父级交易简称
    ,nvl(n.parent_tran_name, o.parent_tran_name) as parent_tran_name -- 父级交易名称
    ,nvl(n.inv_role_name, o.inv_role_name) as inv_role_name -- INV角色名称
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 修改日期
    ,nvl(n.modif_cnt, o.modif_cnt) as modif_cnt -- 修改次数
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fft_bus_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_fft_bus_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.intnal_id <> n.intnal_id
        or o.ref_no <> n.ref_no
        or o.lc_bus_id <> n.lc_bus_id
        or o.tran_sketch <> n.tran_sketch
        or o.pkg_buy_bk_comb <> n.pkg_buy_bk_comb
        or o.present_id <> n.present_id
        or o.present_ps_name <> n.present_ps_name
        or o.rgst_dt <> n.rgst_dt
        or o.open_dt <> n.open_dt
        or o.open_exp_dt <> n.open_exp_dt
        or o.close_flg <> n.close_flg
        or o.close_dt <> n.close_dt
        or o.value_dt <> n.value_dt
        or o.aldy_tran_sell_flg <> n.aldy_tran_sell_flg
        or o.org_id <> n.org_id
        or o.parent_intnal_id <> n.parent_intnal_id
        or o.parent_ref_no <> n.parent_ref_no
        or o.parent_tran_abbr <> n.parent_tran_abbr
        or o.parent_tran_name <> n.parent_tran_name
        or o.inv_role_name <> n.inv_role_name
        or o.modif_dt <> n.modif_dt
        or o.modif_cnt <> n.modif_cnt
        or o.oper_teller_id <> n.oper_teller_id
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_fft_bus_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,ref_no -- 参考号
    ,lc_bus_id -- 信用证业务编号
    ,tran_sketch -- 交易简述
    ,pkg_buy_bk_comb -- 包买行组合
    ,present_id -- 交单编号
    ,present_ps_name -- 交单人名称
    ,rgst_dt -- 登记日期
    ,open_dt -- 开立日期
    ,open_exp_dt -- 开立到期日期
    ,close_flg -- 关闭标志
    ,close_dt -- 关闭日期
    ,value_dt -- 起息日期
    ,aldy_tran_sell_flg -- 已转卖标志
    ,org_id -- 机构编号
    ,parent_intnal_id -- 父级内部编号
    ,parent_ref_no -- 父级参考号
    ,parent_tran_abbr -- 父级交易简称
    ,parent_tran_name -- 父级交易名称
    ,inv_role_name -- INV角色名称
    ,modif_dt -- 修改日期
    ,modif_cnt -- 修改次数
    ,oper_teller_id -- 经办柜员编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fft_bus_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,intnal_id -- 内部编号
    ,ref_no -- 参考号
    ,lc_bus_id -- 信用证业务编号
    ,tran_sketch -- 交易简述
    ,pkg_buy_bk_comb -- 包买行组合
    ,present_id -- 交单编号
    ,present_ps_name -- 交单人名称
    ,rgst_dt -- 登记日期
    ,open_dt -- 开立日期
    ,open_exp_dt -- 开立到期日期
    ,close_flg -- 关闭标志
    ,close_dt -- 关闭日期
    ,value_dt -- 起息日期
    ,aldy_tran_sell_flg -- 已转卖标志
    ,org_id -- 机构编号
    ,parent_intnal_id -- 父级内部编号
    ,parent_ref_no -- 父级参考号
    ,parent_tran_abbr -- 父级交易简称
    ,parent_tran_name -- 父级交易名称
    ,inv_role_name -- INV角色名称
    ,modif_dt -- 修改日期
    ,modif_cnt -- 修改次数
    ,oper_teller_id -- 经办柜员编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.intnal_id -- 内部编号
    ,o.ref_no -- 参考号
    ,o.lc_bus_id -- 信用证业务编号
    ,o.tran_sketch -- 交易简述
    ,o.pkg_buy_bk_comb -- 包买行组合
    ,o.present_id -- 交单编号
    ,o.present_ps_name -- 交单人名称
    ,o.rgst_dt -- 登记日期
    ,o.open_dt -- 开立日期
    ,o.open_exp_dt -- 开立到期日期
    ,o.close_flg -- 关闭标志
    ,o.close_dt -- 关闭日期
    ,o.value_dt -- 起息日期
    ,o.aldy_tran_sell_flg -- 已转卖标志
    ,o.org_id -- 机构编号
    ,o.parent_intnal_id -- 父级内部编号
    ,o.parent_ref_no -- 父级参考号
    ,o.parent_tran_abbr -- 父级交易简称
    ,o.parent_tran_name -- 父级交易名称
    ,o.inv_role_name -- INV角色名称
    ,o.modif_dt -- 修改日期
    ,o.modif_cnt -- 修改次数
    ,o.oper_teller_id -- 经办柜员编号
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fft_bus_info_h_isbsf1_bk o
    left join ${iml_schema}.agt_fft_bus_info_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_fft_bus_info_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_fft_bus_info_h;
--alter table ${iml_schema}.agt_fft_bus_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_fft_bus_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_fft_bus_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_fft_bus_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_fft_bus_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_fft_bus_info_h_isbsf1_cl;
alter table ${iml_schema}.agt_fft_bus_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_fft_bus_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fft_bus_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_fft_bus_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_fft_bus_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_fft_bus_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_fft_bus_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fft_bus_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
