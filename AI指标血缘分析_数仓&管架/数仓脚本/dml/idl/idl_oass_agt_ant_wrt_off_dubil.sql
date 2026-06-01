/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_ant_wrt_off_dubil
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_ant_wrt_off_dubil drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_ant_wrt_off_dubil add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_ant_wrt_off_dubil (
etl_dt  --ETL处理日期
,dubil_id  --借据编号
,cust_id  --客户编号
,dubil_amt  --借据金额
,curr_bal  --当前余额
,exp_dt  --到期日期
,exec_int_rat  --执行利率
,ovdue_days  --贷款逾期天数
,int  --利息
,pnlt  --罚息
,repay_way_cd  --还款方式代码
,tenor  --期限
,acct_instit_id  --账务机构编号
,wrt_off_status_cd  --核销状态代码
,bus_type_cd  --业务类型代码
,distr_dt  --放款日期
,ovdue_dt  --逾期日期
,coll_cnt  --催收次数
,insto_dt  --入库日期
,fir_wrt_off_dt  --首次核销日期
,recvbl_pric  --应收本金
,recvbl_off_bs_int  --应收表外利息
,remark  --备注
,level5_cls_cd  --五级分类代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,advc_fee  --垫付费用
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,t1.dubil_amt as dubil_amt --借据金额
,t1.curr_bal as curr_bal --当前余额
,t1.exp_dt as exp_dt --到期日期
,t1.exec_int_rat as exec_int_rat --执行利率
,t1.ovdue_days as ovdue_days --贷款逾期天数
,t1.int as int --利息
,t1.pnlt as pnlt --罚息
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,t1.tenor as tenor --期限
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id --账务机构编号
,replace(replace(t1.wrt_off_status_cd,chr(13),''),chr(10),'') as wrt_off_status_cd --核销状态代码
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd --业务类型代码
,t1.distr_dt as distr_dt --放款日期
,t1.ovdue_dt as ovdue_dt --逾期日期
,t1.coll_cnt as coll_cnt --催收次数
,t1.insto_dt as insto_dt --入库日期
,t1.fir_wrt_off_dt as fir_wrt_off_dt --首次核销日期
,t1.recvbl_pric as recvbl_pric --应收本金
,t1.recvbl_off_bs_int as recvbl_off_bs_int --应收表外利息
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd --五级分类代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,t1.advc_fee as advc_fee --垫付费用
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_ant_wrt_off_dubil t1    --蚂蚁核销借据
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_ant_wrt_off_dubil',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
