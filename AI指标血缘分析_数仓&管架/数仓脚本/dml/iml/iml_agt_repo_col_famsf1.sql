/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_repo_col_famsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_repo_col_famsf1_tm purge;
drop table ${iml_schema}.agt_repo_col_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_repo_col add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_repo_col modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_repo_col_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_repo_col partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_repo_col_famsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,tran_flow_num -- 交易流水号
    ,bond_type_cd -- 债券类型代码
    ,col_id -- 抵押品编号
    ,mtg_seq_num -- 抵押顺序号
    ,convt_ratio -- 折算比例
    ,cert_face_tot -- 券面总额
    ,stl_amt -- 结算金额
    ,full_price -- 全价
    ,net_price -- 净价
    ,acru_int -- 应计利息
    ,fst_yld_rat -- 首期收益率
    ,full_price_tot -- 全价总额
    ,bond_issuer_id -- 债券发行人编号
    ,exp_net_price -- 到期净价
    ,exp_full_price -- 到期全价
    ,exp_hundred_y_acru_int -- 到期百元应计利息
    ,exp_yld_rat -- 到期收益率
    ,actl_exp_full_price -- 实际到期全价
    ,exp_acru_int_tot -- 到期应计利息总额
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_repo_col
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_repo_col_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_repo_col partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_rep_asset-
insert into ${iml_schema}.agt_repo_col_famsf1_tm(
    asset_id -- 资产编号
    ,agt_id -- 法人编号
    ,lp_id -- 协议编号
    ,tran_flow_num -- 交易流水号
    ,bond_type_cd -- 债券类型代码
    ,col_id -- 抵押品编号
    ,mtg_seq_num -- 抵押顺序号
    ,convt_ratio -- 折算比例
    ,cert_face_tot -- 券面总额
    ,stl_amt -- 结算金额
    ,full_price -- 全价
    ,net_price -- 净价
    ,acru_int -- 应计利息
    ,fst_yld_rat -- 首期收益率
    ,full_price_tot -- 全价总额
    ,bond_issuer_id -- 债券发行人编号
    ,exp_net_price -- 到期净价
    ,exp_full_price -- 到期全价
    ,exp_hundred_y_acru_int -- 到期百元应计利息
    ,exp_yld_rat -- 到期收益率
    ,actl_exp_full_price -- 实际到期全价
    ,exp_acru_int_tot -- 到期应计利息总额
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.RPASUUID -- 资产编号
    ,'225106'||P1.REPDUUID -- 法人编号
    ,'9999' -- 协议编号
    ,P1.REPDUUID -- 交易流水号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P2.SECTYPE END -- 债券类型代码
    ,P1.ASSETUUID -- 抵押品编号
    ,TO_CHAR(P1.SEQNO) -- 抵押顺序号
    ,P1.CONVRATE -- 折算比例
    ,P1.FACETOTALAMT -- 券面总额
    ,P1.DEALAMT -- 结算金额
    ,P1.VDPRICE -- 全价
    ,P1.VCPRICE -- 净价
    ,P1.VACCUIR -- 应计利息
    ,P1.VYIELD -- 首期收益率
    ,P1.VDPRICEAMT -- 全价总额
    ,P2.ISSUERSHORT -- 债券发行人编号
    ,trunc(P1.MCPRICE,12) -- 到期净价
    ,P1.MDPRICE -- 到期全价
    ,P1.MACCUIR -- 到期百元应计利息
    ,P1.MYIELD -- 到期收益率
    ,trunc(P1.MDPRICEAMT,8) -- 实际到期全价
    ,P1.MACCUIRAMT -- 到期应计利息总额
    ,P1.EFFECTFLAG -- 有效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_rep_asset' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_rep_asset p1
    left join ${iol_schema}.fams_src_secinfo p2 on P2.SECID =P1.ASSETUUID AND P2.start_dt <= to_date('${batch_date}','yyyymmdd') and P2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on NVL(P2.SECTYPE,' ') = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_SRC_SECINFO'
        AND R1.SRC_FIELD_EN_NAME= 'SECTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_REPO_COL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BOND_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_repo_col_famsf1_tm 
  	                                group by 
  	                                        asset_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_repo_col_famsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,tran_flow_num -- 交易流水号
    ,bond_type_cd -- 债券类型代码
    ,col_id -- 抵押品编号
    ,mtg_seq_num -- 抵押顺序号
    ,convt_ratio -- 折算比例
    ,cert_face_tot -- 券面总额
    ,stl_amt -- 结算金额
    ,full_price -- 全价
    ,net_price -- 净价
    ,acru_int -- 应计利息
    ,fst_yld_rat -- 首期收益率
    ,full_price_tot -- 全价总额
    ,bond_issuer_id -- 债券发行人编号
    ,exp_net_price -- 到期净价
    ,exp_full_price -- 到期全价
    ,exp_hundred_y_acru_int -- 到期百元应计利息
    ,exp_yld_rat -- 到期收益率
    ,actl_exp_full_price -- 实际到期全价
    ,exp_acru_int_tot -- 到期应计利息总额
    ,valid_flg -- 有效标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.bond_type_cd, o.bond_type_cd) as bond_type_cd -- 债券类型代码
    ,nvl(n.col_id, o.col_id) as col_id -- 抵押品编号
    ,nvl(n.mtg_seq_num, o.mtg_seq_num) as mtg_seq_num -- 抵押顺序号
    ,nvl(n.convt_ratio, o.convt_ratio) as convt_ratio -- 折算比例
    ,nvl(n.cert_face_tot, o.cert_face_tot) as cert_face_tot -- 券面总额
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 结算金额
    ,nvl(n.full_price, o.full_price) as full_price -- 全价
    ,nvl(n.net_price, o.net_price) as net_price -- 净价
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.fst_yld_rat, o.fst_yld_rat) as fst_yld_rat -- 首期收益率
    ,nvl(n.full_price_tot, o.full_price_tot) as full_price_tot -- 全价总额
    ,nvl(n.bond_issuer_id, o.bond_issuer_id) as bond_issuer_id -- 债券发行人编号
    ,nvl(n.exp_net_price, o.exp_net_price) as exp_net_price -- 到期净价
    ,nvl(n.exp_full_price, o.exp_full_price) as exp_full_price -- 到期全价
    ,nvl(n.exp_hundred_y_acru_int, o.exp_hundred_y_acru_int) as exp_hundred_y_acru_int -- 到期百元应计利息
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.actl_exp_full_price, o.actl_exp_full_price) as actl_exp_full_price -- 实际到期全价
    ,nvl(n.exp_acru_int_tot, o.exp_acru_int_tot) as exp_acru_int_tot -- 到期应计利息总额
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.agt_id <> n.agt_id
                or o.tran_flow_num <> n.tran_flow_num
                or o.bond_type_cd <> n.bond_type_cd
                or o.col_id <> n.col_id
                or o.mtg_seq_num <> n.mtg_seq_num
                or o.convt_ratio <> n.convt_ratio
                or o.cert_face_tot <> n.cert_face_tot
                or o.stl_amt <> n.stl_amt
                or o.full_price <> n.full_price
                or o.net_price <> n.net_price
                or o.acru_int <> n.acru_int
                or o.fst_yld_rat <> n.fst_yld_rat
                or o.full_price_tot <> n.full_price_tot
                or o.bond_issuer_id <> n.bond_issuer_id
                or o.exp_net_price <> n.exp_net_price
                or o.exp_full_price <> n.exp_full_price
                or o.exp_hundred_y_acru_int <> n.exp_hundred_y_acru_int
                or o.exp_yld_rat <> n.exp_yld_rat
                or o.actl_exp_full_price <> n.actl_exp_full_price
                or o.exp_acru_int_tot <> n.exp_acru_int_tot
                or o.valid_flg <> n.valid_flg
            ) or (
                 case when (
                           n.asset_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.asset_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_repo_col_famsf1_tm n
    full join ${iml_schema}.agt_repo_col_famsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_repo_col truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_repo_col exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.agt_repo_col_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_repo_col drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_repo_col to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_repo_col_famsf1_tm purge;
drop table ${iml_schema}.agt_repo_col_famsf1_ex purge;
drop table ${iml_schema}.agt_repo_col_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_repo_col', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);