/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bond_tran
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
alter table ${idl_schema}.oass_agt_bond_tran drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bond_tran add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bond_tran (
etl_dt  --ETL处理日期
,bus_id  --业务编号
,bus_table_name  --业务表名称
,dept_id  --部门编号
,bond_id  --债券编号
,bond_name  --债券名称
,bond_type_cd  --债券类型代码
,tran_id  --交易编号
,tran_dt  --交易日期
,dlvy_dt  --交割日期
,tran_dir_cd  --交易方向代码
,curr_cd  --币种代码
,tran_net_price  --交易净价
,tran_full_price  --交易全价
,exp_yld_rat  --到期收益率
,stl_amt  --转贴现金额
,portf_id  --投组编号
,portf_name  --投组名称
,acct_b_id  --账簿编号
,acct_b_name  --账簿名称
,acct_b_attr_cd  --账簿属性代码
,asset_cls4_cd  --资产四分类代码
,cntpty_name  --交易对手名称
,cntpty_id  --交易对手编号
,stl_way_cd  --结算方式代码
,dealer_id  --交易员编号
,dealer_name  --交易员名称
,bag_id  --成交编号
,comm_fee  --手续费
,tax  --税金
,comm  --佣金
,cert_face_tot  --券面总额
,acru_int_tot  --应计利息总额
,cfets_tran_flg  --CFETS交易标志
,tran_src_cd  --交易来源代码
,asset_type_cd  --资产类型代码
,init_bus_id  --原业务编号
,acpt_pay_cfm_modif_tm  --收付确认修改时间
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,std_prod_id  --标准产品编号
,tran_status_cd  --交易状态代码
,dc_dealer_name  --本币交易员名称
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id --业务编号
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name --业务表名称
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id --部门编号
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id --债券编号
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name --债券名称
,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'') as bond_type_cd --债券类型代码
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id --交易编号
,t1.tran_dt as tran_dt --交易日期
,t1.dlvy_dt as dlvy_dt --交割日期
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd --交易方向代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.tran_net_price as tran_net_price --交易净价
,t1.tran_full_price as tran_full_price --交易全价
,t1.exp_yld_rat as exp_yld_rat --到期收益率
,t1.stl_amt as stl_amt --转贴现金额
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id --投组编号
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name --投组名称
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id --账簿编号
,replace(replace(t1.acct_b_name,chr(13),''),chr(10),'') as acct_b_name --账簿名称
,replace(replace(t1.acct_b_attr_cd,chr(13),''),chr(10),'') as acct_b_attr_cd --账簿属性代码
,replace(replace(t1.asset_cls4_cd,chr(13),''),chr(10),'') as asset_cls4_cd --资产四分类代码
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name --交易对手名称
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id --交易对手编号
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd --结算方式代码
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id --交易员编号
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name --交易员名称
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id --成交编号
,t1.comm_fee as comm_fee --手续费
,t1.tax as tax --税金
,t1.comm as comm --佣金
,t1.cert_face_tot as cert_face_tot --券面总额
,t1.acru_int_tot as acru_int_tot --应计利息总额
,replace(replace(t1.cfets_tran_flg,chr(13),''),chr(10),'') as cfets_tran_flg --CFETS交易标志
,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'') as tran_src_cd --交易来源代码
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd --资产类型代码
,replace(replace(t1.init_bus_id,chr(13),''),chr(10),'') as init_bus_id --原业务编号
,t1.acpt_pay_cfm_modif_tm as acpt_pay_cfm_modif_tm --收付确认修改时间
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd --交易状态代码
,replace(replace(t1.dc_dealer_name,chr(13),''),chr(10),'') as dc_dealer_name --本币交易员名称
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_bond_tran t1    --债券交易
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bond_tran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
