import transportation_problem as tp

# 定义产地、产量
s = [('A1', 14), ('A2', 27), ('A3', 19)]
# 定义售量、销量
d = [('B1', 22), ('B2', 13), ('B3', 12), ('B4', 13)]
# 运价表
c = [[6, 7, 5, 3], [8, 4, 2, 7], [5, 9, 10, 6]]

# 初始化运输问题对象
p = tp.TransportationProblem(s, d, c)
# 求解，使用西北角法初始化，位势法检验，闭回路法优化调整
r = p.solve(tp.NorthwestCornerIniter, tp.PotentialChecker, tp.ClosedLoopAdjustmentOptimizer)

# 输出解
print(r)